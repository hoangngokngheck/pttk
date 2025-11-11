package controller;

import dao.DishDAO;
import dao.OrderItemDAO;
import model.Dish;
import model.Member;
import model.OrderItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {

    private DishDAO dishDAO;
    private OrderItemDAO orderItemDAO;

    @Override
    public void init() {
        dishDAO = new DishDAO();
        orderItemDAO = new OrderItemDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Member member = (Member) session.getAttribute("member");

        // Kiểm tra đăng nhập
        if (member == null || !member.isCustomer()) {
            response.sendRedirect("auth");
            return;
        }

        // Xử lý set booking từ trang tra cứu
        String setBooking = request.getParameter("setBooking");
        if ("true".equals(setBooking)) {
            String orderIdParam = request.getParameter("orderId");
            String tableIdParam = request.getParameter("tableId");
            
            if (orderIdParam != null && tableIdParam != null) {
                try {
                    int orderId = Integer.parseInt(orderIdParam);
                    int tableId = Integer.parseInt(tableIdParam);
                    
                    // Set vào session
                    session.setAttribute("currentOrderId", orderId);
                    session.setAttribute("currentTableId", tableId);
                    
                    // Redirect về order để load lại
                    response.sendRedirect("order");
                    return;
                } catch (NumberFormatException e) {
                    // Ignore
                }
            }
        }

        // Kiểm tra đã đặt bàn chưa
        Integer currentOrderId = (Integer) session.getAttribute("currentOrderId");
        Integer currentTableId = (Integer) session.getAttribute("currentTableId");
        
        if (currentOrderId == null || currentTableId == null) {
            // Chưa đặt bàn -> chuyển đến trang đặt bàn
            response.sendRedirect("table");
            return;
        }

        String dishIdParam = request.getParameter("dishId");

        // Không có dishId -> hiển thị danh sách món
        if (dishIdParam == null) {
            List<Dish> dishList = dishDAO.findAll();
            request.setAttribute("dishList", dishList);
            request.setAttribute("currentTableId", currentTableId);
            request.setAttribute("currentOrderId", currentOrderId);
            request.getRequestDispatcher("orderList.jsp").forward(request, response);
            return;
        }

        // Có dishId -> hiển thị form đặt món
        try {
            int dishId = Integer.parseInt(dishIdParam);
            Dish dish = dishDAO.getDishById(dishId);

            if (dish == null) {
                response.sendRedirect("order");
                return;
            }

            request.setAttribute("dish", dish);
            request.setAttribute("currentTableId", currentTableId);
            request.setAttribute("currentOrderId", currentOrderId);
            request.getRequestDispatcher("orderForm.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("order");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Member member = (Member) session.getAttribute("member");

        // Kiểm tra đăng nhập
        if (member == null || !member.isCustomer()) {
            response.sendRedirect("auth");
            return;
        }

        // Kiểm tra đã đặt bàn chưa
        Integer currentOrderId = (Integer) session.getAttribute("currentOrderId");
        
        if (currentOrderId == null) {
            response.sendRedirect("table");
            return;
        }

        try {
            int dishId = Integer.parseInt(request.getParameter("dishId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            // Lấy thông tin món
            Dish dish = dishDAO.getDishById(dishId);
            if (dish == null) {
                response.sendRedirect("order");
                return;
            }

            // Thêm món vào order
            OrderItem item = new OrderItem();
            item.setOrderId(currentOrderId);
            item.setDishId(dishId);
            item.setQuantity(quantity);
            item.setPrice(dish.getPrice());

            orderItemDAO.addOrderItem(item);

            // Chuyển đến trang thành công
            request.setAttribute("dish", dish);
            request.setAttribute("quantity", quantity);
            request.getRequestDispatcher("orderSuccess.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("order");
        }
    }
}

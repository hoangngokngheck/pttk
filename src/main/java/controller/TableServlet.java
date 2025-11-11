package controller;

import dao.TableDAO;
import model.Table;
import model.TableBookingInfo;
import model.Member;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/table")
public class TableServlet extends HttpServlet {

    private TableDAO tableDAO;

    @Override
    public void init() {
        tableDAO = new TableDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Member member = (Member) session.getAttribute("member");
        String action = request.getParameter("action");

        // Kiểm tra đăng nhập
        if (member == null) {
            response.sendRedirect("auth");
            return;
        }

        // Xử lý tìm kiếm bàn đã đặt
        if ("search".equals(action)) {
            handleSearch(request, response, member);
            return;
        }

        // Chỉ customer mới được đặt bàn
        if (!member.isCustomer()) {
            response.sendRedirect("auth");
            return;
        }

        // Lấy danh sách bàn trống
        List<Table> availableTables = tableDAO.getAvailableTables();
        request.setAttribute("availableTables", availableTables);
        request.getRequestDispatcher("tableBooking.jsp").forward(request, response);
    }

    /**
     * Xử lý tìm kiếm bàn đã đặt
     */
    private void handleSearch(HttpServletRequest request, HttpServletResponse response, Member member)
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        List<TableBookingInfo> bookings;

        if (keyword != null && !keyword.trim().isEmpty()) {
            // Tìm kiếm theo keyword
            bookings = tableDAO.searchBookings(keyword.trim());
            request.setAttribute("keyword", keyword.trim());
        } else {
            // Hiển thị tất cả
            bookings = tableDAO.getAllBookings();
        }

        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("tableSearch.jsp").forward(request, response);
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

        String tableIdParam = request.getParameter("tableId");
        
        // Validate
        if (tableIdParam == null || tableIdParam.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn một bàn!");
            doGet(request, response);
            return;
        }

        try {
            int tableId = Integer.parseInt(tableIdParam);
            
            // Đặt bàn
            int orderId = tableDAO.bookTable(tableId, member.getId());
            
            if (orderId > 0) {
                // Lưu thông tin vào session
                session.setAttribute("currentOrderId", orderId);
                session.setAttribute("currentTableId", tableId);
                
                // Redirect đến trang đặt món
                response.sendRedirect("order");
            } else {
                request.setAttribute("error", "Đặt bàn thất bại! Bàn có thể đã được đặt.");
                doGet(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Thông tin bàn không hợp lệ!");
            doGet(request, response);
        }
    }
}

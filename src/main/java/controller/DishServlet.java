package controller;

import dao.DishDAO;
import dao.DishCategoryDAO;
import model.Dish;
import model.DishCategory;
import model.Member;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/dish")
public class DishServlet extends HttpServlet {
    private final DishDAO dao = new DishDAO();
    private final DishCategoryDAO categoryDAO = new DishCategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        if (action == null) action = "list";

        // Kiểm tra đăng nhập cho các chức năng quản lý (add, edit, delete)
        if ("add".equals(action) || "edit".equals(action) || "delete".equals(action)) {
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("member") == null) {
                resp.sendRedirect("auth?error=login_required");
                return;
            }

            Member member = (Member) session.getAttribute("member");
            if (!member.isManager()) {
                req.setAttribute("error", "Chỉ Manager mới có quyền quản lý món ăn!");
                List<Dish> dishes = dao.findAll();
                req.setAttribute("dishes", dishes);
                req.getRequestDispatcher("dishList.jsp").forward(req, resp);
                return;
            }
        }

        switch (action) {
            case "add":
                // Lấy danh sách category để hiển thị trong form
                List<DishCategory> categories = categoryDAO.getAllCategories();
                req.setAttribute("categories", categories);
                req.setAttribute("mode", "create");
                req.getRequestDispatcher("dishForm.jsp").forward(req, resp);
                break;

            case "edit":
                try {
                    int dishId = Integer.parseInt(req.getParameter("id"));
                    Dish d = dao.getDishById(dishId); // Sử dụng getDishById() theo UML
                    if (d == null) {
                        resp.sendRedirect("dish");
                        return;
                    }
                    // Lấy danh sách category để hiển thị trong form
                    List<DishCategory> editCategories = categoryDAO.getAllCategories();
                    req.setAttribute("categories", editCategories);
                    req.setAttribute("dish", d);
                    req.setAttribute("mode", "update");
                    req.getRequestDispatcher("dishForm.jsp").forward(req, resp);
                } catch (Exception e) {
                    e.printStackTrace();
                    resp.sendRedirect("dish");
                }
                break;

            case "search":
                // Chức năng tìm kiếm món ăn theo tên - theo UML
                String searchName = req.getParameter("name");
                if (searchName != null && !searchName.trim().isEmpty()) {
                    List<Dish> searchResults = dao.getDishByName(searchName);
                    req.setAttribute("dishes", searchResults);
                    req.setAttribute("searchName", searchName);
                    req.setAttribute("searchResult", searchResults.size() > 0 ? 
                        "Tìm thấy " + searchResults.size() + " món ăn" : 
                        "Không tìm thấy món ăn nào");
                } else {
                    List<Dish> dishes = dao.findAll();
                    req.setAttribute("dishes", dishes);
                }
                req.getRequestDispatcher("dishList.jsp").forward(req, resp);
                break;

            case "delete":
                try {
                    int dishId = Integer.parseInt(req.getParameter("id"));
                    dao.delete(dishId);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                resp.sendRedirect("dish");
                break;

            case "list":
            default:
                List<Dish> dishes = dao.findAll();
                req.setAttribute("dishes", dishes);
                req.getRequestDispatcher("dishList.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        // Kiểm tra đăng nhập - chỉ Manager mới được thêm/sửa món
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("member") == null) {
            resp.sendRedirect("auth?error=login_required");
            return;
        }

        Member member = (Member) session.getAttribute("member");
        if (!member.isManager()) {
            req.setAttribute("error", "Chỉ Manager mới có quyền quản lý món ăn!");
            List<Dish> dishes = dao.findAll();
            req.setAttribute("dishes", dishes);
            req.getRequestDispatcher("dishList.jsp").forward(req, resp);
            return;
        }

        String action = req.getParameter("action");
        String name = req.getParameter("name");
        int price = Integer.parseInt(req.getParameter("price"));
        String description = req.getParameter("description");
        String categoryIdParam = req.getParameter("categoryId");

        if ("create".equals(action)) {
            Dish d = new Dish(name, price, description);
            // Xử lý category nếu có
            if (categoryIdParam != null && !categoryIdParam.trim().isEmpty()) {
                try {
                    int categoryId = Integer.parseInt(categoryIdParam);
                    DishCategory category = new DishCategory();
                    category.setCategoryId(categoryId);
                    d.setCategory(category);
                } catch (NumberFormatException e) {
                    // Bỏ qua nếu categoryId không hợp lệ
                }
            }
            dao.create(d);
            req.getSession().setAttribute("updateResult", "Thêm món ăn thành công!");
        } else if ("update".equals(action)) {
            int dishId = Integer.parseInt(req.getParameter("id"));
            Dish d = new Dish(dishId, name, price, description);
            // Xử lý category nếu có
            if (categoryIdParam != null && !categoryIdParam.trim().isEmpty()) {
                try {
                    int categoryId = Integer.parseInt(categoryIdParam);
                    DishCategory category = new DishCategory();
                    category.setCategoryId(categoryId);
                    d.setCategory(category);
                } catch (NumberFormatException e) {
                    // Bỏ qua nếu categoryId không hợp lệ
                }
            }
            // Sử dụng updateDish() theo UML, return boolean
            boolean success = dao.updateDish(d);
            if (success) {
                req.getSession().setAttribute("updateResult", "Cập nhật món ăn thành công!");
            } else {
                req.getSession().setAttribute("updateResult", "Cập nhật món ăn thất bại!");
            }
        }
        resp.sendRedirect("dish");
    }
}

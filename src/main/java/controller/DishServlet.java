package controller;

import dao.DishDAO;
import model.Dish;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/dish")
public class DishServlet extends HttpServlet {
    private final DishDAO dao = new DishDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                req.setAttribute("mode", "create");
                req.getRequestDispatcher("dishForm.jsp").forward(req, resp);
                break;

            case "edit":
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    Dish d = dao.findById(id);
                    req.setAttribute("dish", d);
                    req.setAttribute("mode", "update");
                    req.getRequestDispatcher("dishForm.jsp").forward(req, resp);
                } catch (Exception e) {
                    resp.sendRedirect("dish");
                }
                break;

            case "delete":
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    dao.delete(id);
                } catch (Exception ignored) {}
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

        String action = req.getParameter("action");
        String name = req.getParameter("name");
        int price = Integer.parseInt(req.getParameter("price")); // sửa sang int
        String description = req.getParameter("description");

        if ("create".equals(action)) {
            dao.create(new Dish(name, price, description));
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            Dish d = new Dish(id, name, price, description);
            dao.update(d);
        }
        resp.sendRedirect("dish");
    }
}

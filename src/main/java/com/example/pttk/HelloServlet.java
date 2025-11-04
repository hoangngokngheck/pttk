package com.example.pttk;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "helloServlet", value = "/hello-servlet")
public class HelloServlet extends HttpServlet {

    private String message;

    @Override
    public void init() throws ServletException {
        message = "Hello, World! This is PTTK project running on Tomcat 10 🚀";
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<html><head><title>Hello Servlet</title></head><body>");
        out.println("<h1 style='color:blue; text-align:center;'>" + message + "</h1>");
        out.println("<p style='text-align:center;'>✅ Servlet is working perfectly!</p>");
        out.println("</body></html>");
    }

    @Override
    public void destroy() {
        // clean up if needed
    }
}

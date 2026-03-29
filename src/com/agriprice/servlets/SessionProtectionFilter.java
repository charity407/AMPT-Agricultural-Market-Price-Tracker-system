package com.agriprice.servlets;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Protects ALL /jsp/* pages from unauthenticated access.
 * Runs automatically before every JSP page loads.
 * If no valid session → redirect to login.html
 */
@WebFilter("/jsp/*")
public class SessionProtectionFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req = (HttpServletRequest)  request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session  = req.getSession(false);
        boolean     loggedIn = session != null && session.getAttribute("userId") != null;

        if (loggedIn) {
            chain.doFilter(request, response); // allow through
        } else {
            res.sendRedirect(req.getContextPath() + "/login.html"); // block
        }
    }

    @Override
    public void destroy() {}
}


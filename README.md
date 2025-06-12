# FinanceManagement
A personal finance tracker built with MySQL and Python that allows users to log income and expenses, categorize transactions, and generate monthly and yearly financial summaries. Work in progress- features still being added.

# Personal Finance Tracker

A personal finance tracking system built with **MySQL** and **Python**. This project allows users to:

- Register and log in securely
- Log income and expense transactions
- Categorize spending
- Generate monthly and yearly financial summaries
- Track net balances and category breakdowns

---

## Features

 User authentication with username and password  
 Add, update, delete, and view transactions  
 Income vs. expense tracking  
 Monthly summaries and net balance reports  
 Category-based breakdowns  
 Organized with MySQL stored procedures  
 Easily extensible with a GUI or API

---

## Technologies Used

- **Python 3**
- **MySQL 8+**
- **MySQL Stored Procedures**
- (Optional) **Tkinter** or **Flask** for GUI/web interface

---

## Database Schema

- `users` – Stores user login data  
- `transactions` – Stores income/expenses  
- `category` – Stores transaction categories  

Stored procedures include:

- `RegisterUser`
- `LoginUser`
- `AddTransaction`, `UpdateTransaction`, `DeleteTransaction`
- `MonthlyIncome`, `MonthlyExpenses`, `MonthlyNetBalance`
- `GetTransactionByMonth`, `GetTransactionByUser`
- `CategoryBreakdown`, `YearlySummary`

---

## Security

- Login credentials use parameterized queries (to prevent SQL injection)  
- Password hashing (recommended for production use)  
- All queries avoid exposing raw SQL in user interfaces  

---

## Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/finance-tracker.git
cd finance-tracker

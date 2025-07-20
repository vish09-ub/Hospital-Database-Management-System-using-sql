# 🏥 Hospital Database Management System

This project focuses on designing a relational database for managing hospital operations efficiently. Using MySQL, we implemented a structured system that stores and queries data related to patients, physicians, departments, appointments, procedures, and treatments, ensuring data integrity and enabling insightful analysis through SQL.

## 📌 Project Overview

Hospitals generate a massive volume of data daily. Managing this data efficiently is crucial for improving patient care, optimizing operations, and making informed decisions. This project involves creating a hospital database using SQL that simulates real-world healthcare data and supports complex queries.

### 🎯 Objectives

- Design a relational database with primary and foreign key relationships.
- Ensure data consistency using referential integrity.
- Execute SQL queries for healthcare-related insights and reporting.
- Create views and triggers for advanced control and monitoring.

## 🧩 Database Structure

### 🔑 Core Tables:
- `Patient`
- `Physician`
- `Appointment`
- `Department`
- `Nurse`
- `Room`
- `Stay`

### 🔗 Foreign Key Relationships:
- Link patients to their primary care physicians (PCP).
- Link appointments to patients, physicians, and nurses.
- Maintain referential integrity between stays, rooms, procedures, and departments.

### 📌 Advanced Tables:
- `Undergoes`
- `Prescribes`
- `Affiliated_with`
- `Trained_in`
- `On_call`
- `Procedure`

## 🧠 Key SQL Features Implemented

- Complex JOINs across multiple tables  
- Subqueries and nested SELECT statements  
- Grouping and aggregation for summaries  
- Creation of `VIEWS` for patient-room tracking  
- `TRIGGERS` to restrict invalid data entries  
- Updates and filters based on conditions (e.g., PCP name, insurance)

## 🧪 Sample SQL Queries

- Identify physicians who are department heads  
- Count unavailable rooms  
- List patients treated by specific departments  
- Count patients scheduled in a specific exam room  
- Retrieve appointments per physician and rank them  
- Create views showing patient-room-block-floor mapping  
- Trigger to prevent appointments without valid physician affiliation




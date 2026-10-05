# EduSyncer

EduSyncer is a role-based Educational ERP System designed to manage and simplify academic activities through a centralized web-based platform.

## Overview

EduSyncer provides separate functionalities for **Administrators, Teachers, Students, and Guardians**, allowing different users to access features according to their roles.

The system is designed to improve communication, academic management, attendance tracking, examination management, and other educational activities within a single platform.

## User Roles

### Admin

* Manage users and system activities
* Manage classes and subjects
* Manage teachers and students
* Monitor academic information
* Manage system-level operations

### Teacher

* Manage assigned classes and subjects
* Record student attendance
* Enter examination marks
* Communicate with guardians
* Manage academic activities

### Student

* View academic information
* View examination results

### Guardian

* Monitor student's academic information
* View attendance
* View examination results
* Communicate with teachers
* Track student's academic progress

## Key Features

* Role-based authentication and authorization
* Student management
* Teacher management
* Guardian management
* Class management
* Subject management
* Teacher allocation
* Attendance management
* Examination and marks management
* Internal messaging system
* Centralized academic database

## Technology Stack

* **Frontend:** JSP, HTML, CSS, JavaScript
* **Backend:** JSP
* **Database:** Oracle Database
* **Server:** Apache Tomcat
* **Development Environment:** Eclipse IDE

## Database

The project uses an Oracle relational database with multiple interconnected tables for managing users, students, teachers, classes, subjects, attendance, examination marks, messages, and teacher allocations.

## System Architecture

The system follows a role-based architecture where users are authenticated and provided with access to functionalities according to their assigned role.

```text
                    EduSyncer
                       |
        ---------------------------------
        |        |          |           |
       Admin   Teacher    Student    Guardian
        |        |          |           |
        ---------------------------------
                       |
                 Oracle Database
```

## Project Purpose

The main objective of EduSyncer is to provide a centralized educational management platform that reduces manual academic management and improves communication between administrators, teachers, and guardians.

## Project Team

* **Ummey Touhidi Farhana**
* **Nabia Sayed Anika**
* **Sabbir Hawlader**

## Academic Project

This project was developed as an academic project for the **IDP-1** course.

## Live Demo

The application currently runs in a local development environment.

```text
http://localhost:8080/IDP-1_Final/
```

> Note: The above URL is a local development URL and is not publicly accessible.

## Repository

GitHub:
https://github.com/farhana331/edusyncer

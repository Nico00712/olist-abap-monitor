# olist-abap-monitor

## Project Overview
An ABAP Cloud portfolio based on the Brazilian Olist e-commerce dataset.

The objective is to design an implement a backend application using modern SAP development technologies,
including ABAP SQL, Core Data Service (CDS), object-oriented ABAP, and the RESTful Application Programming Model (RAP).

## Business Objectives

The application will answer the following questions:

1. Which orders were delivered later than expected?
2. Which sellers are associated with delayed orders?
3. How do customer review scores vary with delivery performance?
4. What are product, freight, and payment totals per order?

## Technology Stack
- SAP ABAP Cloud
- ABAP SQL, Dictionary
- ABAP Core Data Services (CDS)
- RESTful Application Programming Model (RAP)
- SAP Fiori Elements
- OData V4
- ABAP Unit and ATC
- abapGit and Github

## Dataset
The project uses the Brazilian Olist e-commerce dataset.
Source: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

Original Olist data is not committed to this repository.

## Project Status
Currently under development.


# Olist Database - ERD (Entity Relationship Diagram)

This diagram documents the planned data model for the Olist Fulfillment Monitor.

```mermaid
erDiagram
    CUSTOMER {
        string customer_id PK
        string customer_unique_id
        string postcode_prefix
        string state
    }

    ORDER {
        string order_id PK
        string customer_id FK
        string order_status
        date estimated_delivery
        date delivered_date
    }

    ORDER_ITEM {
        string order_id PK,FK
        int item_number PK
        string product_id FK
        string seller_id FK
    }

    PRODUCT {
        string product_id PK
        string category_code FK
    }

    SELLER {
        string seller_id PK
        string postcode_prefix
        string state
    }

    PAYMENT {
        string order_id PK,FK
        int payment_sequence PK
    }

    REVIEW {
        string order_id PK,FK
        string review_id PK
    }

    CATEGORY {
        string category_code PK
    }

    GEO {
        string postcode_prefix PK
        string state PK
    }

    FOLLOW_UP {
        string followup_uuid PK
        string order_id FK
        string status
    }

    CUSTOMER ||--o{ ORDER : places
    ORDER ||--o{ ORDER_ITEM : contains
```






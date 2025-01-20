# Supermarket-Analysis

## Problem Statement

AtliQ Mart is a retail giant with over 50 supermarkets in the southern region of India. All their 50 stores ran a massive promotion during the Diwali 2023 and Sankranti 2024 (festive time in India) on their AtliQ branded products. Now the sales director wants to understand which promotions did well and which did not so that they can make informed decisions for their next promotional period.

Tableau Dashboard - [Link](https://public.tableau.com/app/profile/aditya.kar5369/viz/SupermarketDashboard_17371815999030/Dashboard1?publish=yes)

## Recommended Insights

### Store Performance Analysis:

1. Which are the top 10 stores in terms of Incremental Revenue (IR) generated from the promotions?

    <img width="170" alt="Screenshot 2025-01-17 135447" src="https://github.com/user-attachments/assets/391ca935-cf49-4268-98e8-84a9d7b22516" />

2. Which are the bottom 10 stores when it comes to Incremental Sold Units (ISU) during the promotional period?

    <img width="188" alt="Screenshot 2025-01-17 135604" src="https://github.com/user-attachments/assets/219355f7-6eaf-42c8-8edc-7c3c1075f193" />

3. How does the performance of stores vary by city? Are there any common characteristics among the top-performing stores that could be leveraged across other stores?

    <img width="301" alt="Screenshot 2025-01-17 135730" src="https://github.com/user-attachments/assets/b39722e6-a9f8-45f8-94eb-f0688170d522" />

### Promotion Type Analysis:

4. What are the top 2 promotion types that resulted in the highest Incremental Revenue?

    <img width="170" alt="Screenshot 2025-01-17 135835" src="https://github.com/user-attachments/assets/f97a845b-12d7-44e1-af51-25e8d849676c" />

5. What are the bottom 2 promotion types in terms of their impact on Incremental Sold Units?

    <img width="215" alt="Screenshot 2025-01-17 135928" src="https://github.com/user-attachments/assets/c0201f59-8170-4b83-a828-50180185163c" />

6. Is there a significant difference in the performance of discount-based promotions versus BOGOF (Buy One Get One Free) or cashback promotions?

    <img width="268" alt="Screenshot 2025-01-17 140018" src="https://github.com/user-attachments/assets/2e36570b-aca3-4f3e-b89d-eba899791ad7" />

7. Which promotions strike the best balance between Incremental Sold Units and maintaining healthy margins?

    <img width="215" alt="Screenshot 2025-01-17 140119" src="https://github.com/user-attachments/assets/3b93468a-b92d-426a-b139-d131e5b916e2" />

### Product and Category Analysis:

8. Which product categories saw the most significant lift in sales from the promotions?

    <img width="343" alt="Screenshot 2025-01-17 140216" src="https://github.com/user-attachments/assets/600fca7e-e049-4cfb-b6da-11130a79df63" />

9. Are there specific products that respond exceptionally well or poorly to promotions?

    <img width="365" alt="Screenshot 2025-01-17 140328" src="https://github.com/user-attachments/assets/a1a5cb3b-e387-48af-903f-860f0d3cf7de" />

 10. What is the correlation between product category and promotion type effectiveness?
     
     <img width="479" alt="Screenshot 2025-01-18 101222" src="https://github.com/user-attachments/assets/1c93fe9a-7854-426b-b1c2-84c840bda6b6" />

## Ad-Hoc Analysis

11. Provide a list of products with a base price greater than 500 and that are featured in promo type of 'BOGOF' (Buy One Get One Free). 
    This information will help us identify high-value products that are currently being heavily discounted, which can be useful for evaluating our
    pricing and promotion strategies.

    <img width="261" alt="Screenshot 2025-01-17 140552" src="https://github.com/user-attachments/assets/d83ee203-82cc-49b8-b1f3-3f7a4134524a" />

12. Generate a report that provides an overview of the number of stores in each city. 
    The results will be sorted in descending order of store counts, allowing us to identify the cities with the highest store presence.
    The report includes two essential fields: city and store count, which will assist in optimizing our retail operations.

    <img width="140" alt="Screenshot 2025-01-17 140758" src="https://github.com/user-attachments/assets/d2e5896d-ca68-400d-8c29-e30fb058aa4b" />

13. Generate a report that displays each campaign along with the total revenue generated before and after the campaign? 
    The report includes three key fields: campaign_name, totaI_revenue(before_promotion), totaI_revenue(after_promotion).
    This report should help in evaluating the financial impact of our promotional campaigns. (Display the values in millions)

    <img width="338" alt="Screenshot 2025-01-17 140902" src="https://github.com/user-attachments/assets/526e26e4-3313-4a7c-b0b1-c5b2d1869f1c" />

14. Produce a report that calculates the Incremental Sold Quantity (ISU%) for each category during the Diwali campaign. 
    Additionally, provide rankings for the categories based on their ISU%. The report will include three key fields: category, isu%, and rank order.
    This information will assist in assessing the category-wise success and impact of the Diwali campaign on incremental sales.

    Note: ISU% (Incremental Sold Quantity Percentage) is calculated as the percentage increase/decrease in quantity sold (after promo) 
          compared to quantity sold (before promo)

    <img width="176" alt="Screenshot 2025-01-17 141003" src="https://github.com/user-attachments/assets/ed645b03-7a16-46ff-9412-1031ab3a6a57" />

15. Create a report featuring the Top 5 products, ranked by Incremental Revenue Percentage (IR%), across all campaigns.
    The report will provide essential information including product name, category, and ir%. 
    This analysis helps identify the most successful products in terms of incremental revenue across our campaigns, assisting in product optimization.

    <img width="304" alt="Screenshot 2025-01-17 141059" src="https://github.com/user-attachments/assets/9e8d2596-fcac-45d8-aed0-ce0d77adf3c1" />


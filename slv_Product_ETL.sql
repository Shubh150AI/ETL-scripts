USE SkoolDB


TRUNCATE TABLE slv.Products ;

WITH PRODUCTS_UNIFORM AS (
    SELECT 
        CAST(Size AS DECIMAL)            AS   Product_Size,
        Products                         AS   Product_name,
        Material                         AS   Product_Material,
        CP                               AS   Cost_Price,
        SP                               AS   Selling_Price, 
        Color                            AS   Product_Color,
        'Uniform'                        AS   Product_Category ,
        'UNF'                            AS   Category_Code,
        'Vidyarthi'                      AS   Product_Brand,
        CASE
            WHEN Products = 'Blazer'                              THEN    'BLZR'
            WHEN Products = 'Chained sweatshirt'                  THEN    'CHNDSWTR'
            WHEN Products = 'Full polo t-shirt (Boys)'            THEN    'HPTB'
            WHEN Products = 'Full polo t-shirt (Girls)'           THEN    'FPTSG'
            WHEN Products = 'Full round neck sports t-shirt'      THEN    'HRNSTS'
            WHEN Products = 'Full shirt'                          THEN    'FS'
            WHEN Products = 'Full sweater'                        THEN    'FLSWTR'
            WHEN Products = 'Full trouser'                        THEN    'FT'
            WHEN Products = 'Half polo t-shirt (Boys)'            THEN    'HPTB'
            WHEN Products = 'Half polo t-shirt (Girls)'           THEN    'HPTSG'
            WHEN Products = 'Half round neck sports t-shirt'      THEN    'HRNSTS'
            WHEN Products = 'Half Shirt'                          THEN    'HS'
            WHEN Products = 'Half Sweater'                        THEN    'HLFSWTR'
            WHEN Products = 'Half trouser'                        THEN    'HT'
            WHEN Products = 'Hooded sweatshirt'                   THEN    'HDEDSWTR'
            WHEN Products = 'Jumper skirts'                       THEN    'JMPRSKRT'
            WHEN Products = 'Jumper trousers'                     THEN    'JMPRTR'
            WHEN Products = 'Lab coats'                           THEN    'LCT'
            WHEN Products = 'Salwar'                              THEN    'SLWR'
            WHEN Products = 'Sameej'                              THEN    'SMJ'
            WHEN Products = 'Skirt'                               THEN    'SKRT'
            WHEN Products = 'Track bottom'                        THEN    'TRKBTM'
            WHEN Products = 'Track top'                           THEN    'TRKTP'
            ELSE 'NA'
        END AS Product_ID 
        
    FROM dbo.Product_uniform
),
PRODUCTS_SHOES AS (
    SELECT 
        CAST(Size AS DECIMAL)              AS         Product_Size,
        Products                           AS         Product_name,
        Material                           AS         Product_Material,
        CP                                 AS         Cost_Price,
        SP                                 AS         Selling_Price, 
        Color                              AS         Product_Color,
        Brand                              AS         Product_Brand,
        'Shoes'                            AS         Product_Category ,
        'SHO'                              AS         Category_Code,
        CASE
            WHEN Products = 'Canvas PT'                            THEN     'CNVPT'
            WHEN Products = 'Cloudzade'                            THEN     'CLDZDE'
            WHEN Products = 'RUNNER PT'                            THEN     'RNRPT'
            WHEN Products = 'Sneaker'                              THEN     'SNKR'
            WHEN Products = 'Track Shoe A1'                        THEN     'TSA1'
            WHEN Products = 'Track Shoe A2'                        THEN     'TSA2'
            WHEN Products = 'Velcro sneakers'                      THEN     'VLCRSNKR'
            WHEN Products = 'VelcroG'                              THEN     'VLCRG'
            ELSE 'NA'
        END AS Product_ID 
    FROM dbo.Product_shoes
)
-- Loading the output of combined table into gld.Products

INSERT INTO slv.Products 
                   (
                    Product_Size, 
                    Product_name, 
                    Product_Material, 
                    Cost_Price, 
                    Selling_Price, 
                    Product_Color, 
                    Product_ID, 
                    Item_ID, 
                    Product_Category, 
                    Category_Code, 
                    Product_Brand
                    )

SELECT 
    Product_Size ,
    Product_name ,
    Product_Material ,
    Cost_Price ,
    Selling_Price ,
    Product_Color, 
    Product_ID ,
    CONCAT(Category_Code,'-',Product_ID,'-', Product_Material,'-',Product_Size,'-',Product_Color ) AS Item_ID ,
    Product_Category ,
    Category_Code,
    Product_Brand

FROM PRODUCTS_UNIFORM 

UNION

SELECT 
    Product_Size ,
    Product_name ,
    Product_Material ,
    Cost_Price ,
    Selling_Price ,
    Product_Color, 
    Product_ID ,
    CONCAT(Category_Code,'-',Product_ID,'-', Product_Material,'-',Product_Size,'-',Product_Color ) AS Item_ID ,
    Product_Category ,
    Category_Code,
    Product_Brand

FROM PRODUCTS_SHOES   ;


select * from slv.Products
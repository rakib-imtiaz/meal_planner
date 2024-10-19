drop database if exists diet_database;

create database diet_database;
use diet_database;
-- Users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Recipes table
CREATE TABLE recipes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    ingredients TEXT,
    instructions TEXT,
    energy_per_serving_kcal FLOAT,
    protein_g FLOAT,
    carbohydrate_g FLOAT,
    fat_g FLOAT,
    fiber_g FLOAT,
    image VARCHAR(255),
    serving_size INT,
    prep_time_in_mins INT,
    cook_time_in_mins INT,
    is_vegetarian BOOLEAN,
    is_breakfast BOOLEAN,
    is_lunch BOOLEAN,
    is_snack BOOLEAN,
    is_dinner BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- User favorites table
CREATE TABLE user_favorites (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    recipe_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE,
    UNIQUE (user_id, recipe_id)
);

-- User ratings table
CREATE TABLE user_ratings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    recipe_id INT,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE,
    UNIQUE (user_id, recipe_id)
);

-- Tags table
CREATE TABLE tags (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- Recipe tags table
CREATE TABLE recipe_tags (
    id INT AUTO_INCREMENT PRIMARY KEY,
    recipe_id INT,
    tag_id INT,
    FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE,
    UNIQUE (recipe_id, tag_id)
);

-- User dietary preferences table
CREATE TABLE user_dietary_preferences (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    preference VARCHAR(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE (user_id, preference)
);


--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Chaul Biriyani', 'https://veganbangla.com/wp-content/uploads/2022/07/fullsizeoutput_1d84.jpeg?w=1024', 4, 5, 55, '250 g of Basmati Rice,60ml Vegetable Oil,2 big Onion – Sliced,2-3 fresh Chili,1/4 tsp Turmeric powder,1/4 tsp Cumin powder,1/4 tsp Coriander powder,1 Bay leaf,1 inch cinnamon stick,2 whole Cardamom,1/4 Cumin seeds,2 tsp fine Salt', 1, 0, 1, 0, 1, 380.0, 58.0, 5.4, 14.3, 3.1);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Ruti', 'https://veganbangla.com/wp-content/uploads/2020/11/fullsizeoutput_1bff.jpeg?w=900', 4, 15, 5, '100ml water,200-250g Whole Wheat Flour,1tsp Salt,1tsp Oil', 1, 1, 1, 0, 1, 201.0, 40.5, 7.3, 2.5, 5.6);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Bhaja Bhat', 'https://veganbangla.com/wp-content/uploads/2020/07/fullsizeoutput_d9a.jpeg?w=900', 3, 5, 15, '500 g of leftover rice,Veggies,Edamame beans,20ml Vegetable Oil,1 big Onion Sliced, 2-3 fresh Chili and dried chili,1 tbs Cumin seeds (Cuminum cyminum),2 tsp fine Salt', 1, 1, 1, 0, 1, 368.0, 61.7, 10.1, 9.0, 5.6);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Vegetable Khichuri ', 'https://veganbangla.com/wp-content/uploads/2020/06/fullsizeoutput_c6a.jpeg?w=1024', 8, 5, 50, '500 g of Bashmoti Rice,250g of red Lentil (Mashur Daal/Lens culinaris) or Pulse of your choice,Veggies,60ml Vegetable Oil,1 big Onion – Sliced,2-3 fresh Chili and dried chili,1 tsp Turmeric powder,1tsp Cumin powder ,2 Bay leaf,1 tbs Cumin seeds (Cuminum cyminum),2 tsp fine Salt', 1, 1, 1, 0, 1, 438.0, 76.6, 13.7, 8.3, 5.2);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Kalijira Bhorrta', 'https://veganbangla.com/wp-content/uploads/2024/01/fullsizeoutput_2d1a.jpeg?w=900', 4, 10, 10, '1 cup Nigella seed,1 medium white Onion,1/4 tbs fine Salt,20ml Bangladeshi Mustard Oil,Dried Chili – as desired, Garlic – as desired', 1, 0, 1, 0, 1, 185.0, 18.4, 6.0, 12.2, 4.4);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Kathaler Bichi Bhorrta', 'https://veganbangla.com/wp-content/uploads/2023/09/fullsizeoutput_2a1a.jpeg?w=900', 4, 30, 30, '150g Jackfruit seed- dried and peeled,1 medium white Onion,1/4 tbs fine Salt,20ml Bangladeshi Mustard Oil,Dried Chili – as desired', 1, 0, 1, 0, 1, 126.0, 17.2, 3.0, 5.1, 1.4);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Jaam Alu Bhorrta', 'https://veganbangla.com/wp-content/uploads/2023/02/fullsizeoutput_2511.jpeg?w=900', 4, 30, 30, '500g Red Potatoes,1 big Onion,1 tbs fine Salt,60ml Bangladeshi Mustard Oil,Dried Chili – as desired,20ml Vegetable Oil to fry', 1, 0, 1, 0, 1, 255.0, 23.9, 2.9, 17.8, 3.6);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Dhonia Patar Bhorrta', 'https://veganbangla.com/wp-content/uploads/2022/10/fullsizeoutput_225b.jpeg?w=900', 4, 5, 5, 'Green Coriander leaves -250g,Green Chili- as per taste,Garlic – as per taste,Salt – as per taste,Tamarind – 50g', 1, 0, 1, 0, 1, 49.0, 11.2, 1.87, 0.41, 2.48);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Tishi Bhorrta ', 'https://veganbangla.com/wp-content/uploads/2022/09/fullsizeoutput_206e.jpeg?w=900', 4, 15, 5, '1 Cup or 250g Linseed,1 big Onion – Very Finely sliced,8-10 Dry Red Chili ,4-5 Cloves of Garlic,5 tbs Mustard Oil,1tsp Salt', 1, 0, 1, 0, 1, 444.0, 23.4, 12.2, 36.4, 18.1);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Begun Bhorrta', 'https://veganbangla.com/wp-content/uploads/2022/07/fullsizeoutput_1e0d.jpeg?w=1024', 5, 30, 5, '3 Aubergines,1 big white Onion,Few green chilis,Mustard oil,Salt to taste', 1, 0, 1, 0, 1, 93.47, 9.64, 1.62, 6.02, 3.56);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Peper Jhol', 'https://veganbangla.com/wp-content/uploads/2023/02/fullsizeoutput_25b3.jpeg?w=900', 5, 10, 40, '1 big green papaya,4-5 big potatoes,1 big onion,1 Tsp Turmeric powder,1 tsp ginger garlic paste,1 tsp coriander powder,1 tsp cumin powder ,1 tsp Nigella seeds,1 tbsp salt1 bay leaf,Green Chilies to taste,oil', 1, 0, 1, 0, 1, 188.3, 35.7, 4.97, 4.08, 6.23);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Alu Mular Shiter Torkari', 'https://veganbangla.com/wp-content/uploads/2023/06/fullsizeoutput_272a.jpeg?w=900', 6, 10, 35, '1 Half Chinese Radish,4 Medium Potatoes,Half a cauliflower,Edamame beans as desired,40ml Vegetable Oil,1 big onion,1tbs fine Salt,1tsp Turmeric powder,1tsp Coriander powder,1tsp Cumin powder,1tsp Chili powder,1tsp Ginger Paste (or Ginger powder),1tsp,Garlic Paste (or Garlic powder),2-3 green Chili (optional),Fresh Coriander leaves (optional)', 1, 0, 1, 0, 1, 166.3, 26.7, 5.76, 5.07, 5.68);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Daal Borar torkary', 'https://veganbangla.com/wp-content/uploads/2022/09/fullsizeoutput_2160.jpeg?w=900', 6, 60, 30, 'Half of a big head of Cauliflower,2-3 medium Potatoes,250g Red Lentil or Moshur Daal,100ml Vegetable Oil,1tsp Nigella Seeds,1-2 Bay leaves,2-3 Dry Red Chili,2-3 Green Chili,3tbs fine Salt,1tsp Turmeric powder,1tsp Coriander powder,1tsp Cumin powder,1tsp Chili powder,1tsp Ginger Paste (or Ginger powder),Fresh Coriander leaves to taste', 1, 0, 1, 0, 1, 199.1, 23.2, 6.83, 10.0, 6.86);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Echorer Torkari ', 'https://veganbangla.com/wp-content/uploads/2022/08/fullsizeoutput_1e0a.jpeg?w=900', 2, 5, 30, '250g of canned Jack-fruit,20ml Vegetable Oil,2 medium white onion,1tbs fine Salt,1tsp Turmeric powder,1tsp Coriander powder,1tsp Cumin powder,1tsp Chili powder,1tsp Gorom Moshla,1tsp Ginger Paste (or Ginger powder),1tsp Garlic Paste (or Garlic powder),2-3 Chili (optional),1 stick of Cinnamon,2-3 Cardamom,1 Bay leaf', 1, 0, 1, 0, 1, 258.0, 49.2, 4.76, 6.93, 5.88);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Phulkopir Rosha ', 'https://veganbangla.com/wp-content/uploads/2020/09/fullsizeoutput_17a9.jpeg?w=900', 5, 5, 30, '1 big head of Cauliflower,2 medium Potatoes,100g Muug Daal,3 tbs Tomato paste or 1 big tomato,20ml Vegetable Oil,1tsp Cumin Seeds,1-2 Bay leaves,2 Green Chili,1tbs fine Salt,1tsp Turmeric powder,1tsp Coriander powder,1tsp Cumin powder,1tsp Chili powder,1tsp Ginger Paste (or Ginger powder)', 1, 0, 1, 0, 1, 201.5, 35.9, 10.55, 3.61, 9.65);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Phulkopir Phulkari', 'https://veganbangla.com/wp-content/uploads/2020/09/fullsizeoutput_16d6.jpeg?w=900', 5, 5, 30, '1 big head of Cauliflower,2 medium Potatoes,1 can Coconut milk or Coconut paste,40ml Vegetable Oil,1tsp Cumin Seeds,2 Bay leaves,2 Dried Chili,2 Green Chili,1tbs fine Salt,1tsp Turmeric powder,1tsp Coriander powder,1tsp Cumin powder,1tsp Chili powder,1tsp,Ginger Paste (or Ginger powder),Gorom Moshla to sprinkle', 1, 0, 1, 0, 1, 334.6, 27.9, 7.5, 24.7, 8.2);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Alu Beguner Torkari', 'https://veganbangla.com/wp-content/uploads/2020/06/fullsizeoutput_bfb.jpeg?w=900', 4, 5, 35, '1 Medium Aubergine,5 Medium Potatoes,40ml Vegetable Oil,1tbs fine Salt,1tsp Turmeric powder,1tsp Coriander powder,1tsp Cumin powder,1tsp Chili powder,1tsp Ginger Paste (or Ginger powder),1tsp Black Cumin (Nigella Seed),2-3 Chili (optional)', 1, 0, 1, 0, 1, 225.2, 39.65, 5.09, 6.35, 7.57);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Pachmishali Sobjir Torkari', 'https://veganbangla.com/wp-content/uploads/2020/05/fullsizeoutput_755.jpeg?w=900', 6, 10, 25, '1 Medium Cauliflower head,4 Big Potatoes,200 gr Edamame beans,200 gr Long beans,40ml Vegetable Oil,1tbs fine Salt,1tsp Turmeric powder,2-3 Chili (optional),1tbs Pach Phoron (mix of cumin, fennel, fenugreek, nigella, mustard seeds)', 1, 0, 1, 0, 1, 228.1, 36.01, 10.16, 6.34, 8.38);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Labra', 'https://veganbangla.com/wp-content/uploads/2020/05/fullsizeoutput_84a.jpeg?w=900', 6, 15, 30, 'Root Vegetables: Peeled and diced in 2cm,4 medium potatoes,1 big sweet potato,500g carrots(you can add same amount of pumpkin, butternut, turnip),Other veggies:1 big Cauliflower/ Broccoli – Chopped in big florets,1/2 cup Edamame beans/peas,1/2 cup Long,Beans/Flat beans,1 big Aubergine – Diced in 4cm long and 2cm thick,3 medium Tomatoes – Diced in quarters,30ml Vegetable Oil,1 inches Ginger – roughly minced ,2 tsp fine Salt,2-3 dried Chili ,1 tsp Turmeric powder,1 Bay leaf,1 tbs Pach Phoron (seed mix of nigella, cumin, fenugreek, anis and mustard —  you can use either of them if you don’t have Pach Phoron at home)', 1, 0, 1, 0, 1, 271.3, 52.2, 9.63, 4.92, 13.18);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Alu Begun Bhadhakopi Torkari', 'https://veganbangla.com/wp-content/uploads/2020/04/fullsizeoutput_5ea.jpeg?w=900', 4, 10, 25, '1 Medium Aubergine (also called Brinjal or Eggplant),4 Big Potato,1/4th of a Medium Cabbage head,40ml Vegetable Oil,1big Onion,1tbs fine Salt,1tsp Ginger paste,1tsp Garlic paste,1tsp Turmeric powder,1tsp Gorom Moshla powder,1tsp Chili powder,1tsp Cumin powder,1tsp Coriander powder,2-3 Chili (optional)', 1, 0, 1, 0, 1, 265.3, 49.11, 6.51, 6.41, 10.03);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Misti Kumra Cholar Daal er Niramish', 'nan', 6, 10, 25, '3 cup Pumpkin,1 cup Chickpea (dried and soaked or canned),1 tsp Ginger paste,1 tsp Coriander paste/powder,1/4tsp Black pepper paste/powder,1 tsp turmeric paste/powder,1 tsp chili paste/powder,1 Bay leaf,1/2 teaspoon cumin seed,1/4 teaspoon of Turmeric powder,5 Green Chili,2 Sliced onion ,2 teaspoon Cumin Powder,1/3rd Cup Vegetable oil,1teaspoon Salt', 1, 0, 1, 0, 1, 198.6, 17.43, 4.32, 13.44, 4.04);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Chichinga Ghonto', 'nan', 4, 8, 25, '2 Snake Gourd or Chichinga,2 Small Potatoes,100g Muug Daal,1 Dry red Chili,2 Green Chili,1 teaspoon Cumin seed,1 teaspoon Ginger Paste,1 teaspoon Turmeric powder,1 teaspoon Cumin Powder,20ml Vegetable oil,1 tablepoon Salt', 1, 0, 1, 0, 1, 179.5, 26.58, 8.0, 5.61, 5.86);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Badhakopi Ghonto', 'nan', 4, 8, 25, '250g Cabbage,1 Onion,2 Cloves of Garlic,2 Fresh Chili,1 teaspoon Salt,1 teaspoon of Turmeric powder,10 ml of Oil ,Fresh Coriander leaves to taste', 1, 0, 1, 0, 1, 52.65, 7.52, 1.35, 2.39, 2.34);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Sojne Patar Bora', 'nan', 4, 10, 30, 'Fresh Moringa leaves: 200g,Green Chili- 2/3 pieces,Onion – 1,Beshon(chick pea flour) – 1/4th cup,Wheat flour – 1/4th cup,Salt- 1tsp,Garlic clove – 1 piece,Oil to fry', 1, 0, 1, 0, 1, 166.7, 17.53, 7.53, 8.81, 2.49);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Echorer Bora', 'nan', 4, 20, 15, 'Green Jackfruit (Canned or fresh),200ml vegetable oil to fry,150-200g Gram Flour or Chick pea flour or Besan,Half tsp of Turmeric powder,Half tsp of Red Chili powder,Half tsp of Cumin powder,Half tsp of Gorom Moshla powder,1 tsp fine Salt,50g Fresh Coriander,2-3 green chili,1 onion', 1, 0, 1, 0, 1, 352.54, 53.54, 12.2, 11.06, 7.07);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Pur Bhora Kakrol', 'nan', 4, 20, 15, 'Spiny Gourd aka Kakrol,200ml vegetable oil to fry ,150-200g Gram Flour or Chick pea flour or Besan,50g of Rice Flour,Half tsp of Turmeric powder,1 tsp fine Salt,200g shreded coconut,50g Fresh Coriander,150g White poppy seeds,2-3 green chili,1 onion', 1, 0, 1, 0, 1, 688.1, 61.13, 20.39, 43.12, 18.19);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Tormujer Khosa diye Daal', 'nan', 4, 10, 30, '250g of white parts of watermelon,1 big potato,20ml Vegetable Oil,1 medium white onion,1tbs fine Salt,1tsp Turmeric powder,1tsp Coriander powder,1tsp Cumin powder,2-3 Chili (optional)', 1, 0, 1, 0, 1, 120.34, 18.14, 2.2, 5.19, 2.75);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Lau er Khosa Bhaji', 'nan', 3, 10, 20, 'Skin of 1 big Bottle Gourd/Lau,20ml Vegetable Oil (Olive/Mustard/Coconut oil, anything will do),1 medium Onion,1 clove Garlic,1tbs fine Salt,1tsp Turmeric powder,2-3 Chili (optional)', 1, 0, 1, 0, 1, 83.73, 7.13, 1.06, 6.17, 1.68);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Kachchi Biryani', 'nan', 8, 60, 120, 'Mutton or Beef,Aromatic rice,Sour yogurt,Ginger paste,Garlic paste,Dried red chili,Nutmeg, Mace,White pepper,Cinnamon,Cardamom,Cloves,Star anise,Raisin,Vegetable oil,Ghee,Potato,Prune,Milk powder,Liquid milk,Fried onion,Black pepper,Caraway,Cashew nuts,Salt', 0, 0, 1, 0, 1, 896.0, 69.44, 40.12, 50.88, 4.26);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Chirar Chop', 'nan', 4, 10, 20, '1/2 cup Flatten rice,1/3 cup Chopped onion,1 tsp Chopped green chilies,1/2 tsp Roasted cumin powder,1/2 tsp Roasted coriander powder ,1/4 tsp Turmeric powder ,1/4 tsp Red chili powder,To taste Salt ,To fry Oil', 1, 0, 0, 1, 0, 89.36, 9.72, 1.06, 5.4, 0.82);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Sujir Barfi Halwa ', 'nan', 4, 5, 20, '1 cup Semolina,1/2 cup or to taste Sugar,2 tbsp Ghee or clarified butter,2 pcs or 1/4 tsp powder Cardamom ,2 pcs or 1/4 tsp powder Cinnamon,1 and 1/2 cup Liquid milk or water,Just a pinch Salt', 1, 1, 0, 1, 0, 347.45, 58.66, 8.18, 8.82, 1.76);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Ilish Polao', 'nan', 5, 20, 45, 'Hilsa fish – 600g,Normal rice – 300g,Chopped onion – 100g,Green chilies – 20g,Vegetable oil – 2 tbsp,Turmeric powder,Coconut milk,Salt – to taste', 0, 0, 1, 0, 1, 1061.0, 73.65, 42.9, 67.05, 4.09);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Palm Cake', 'nan', 4, 20, 30, '1 cup Palm pulp,2 cups Rice flour,1/2 cup All purpose flour ,3/4 cup Sugar ,To taste Salt,For deep fry Oil', 1, 1, 0, 1, 0, 574.93, 113.5, 5.45, 10.87, 2.03);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Beef Tehari ', 'nan', 4, 40, 90, '500 gm Aromatic rice (Basmati/Kalojeera/Chinigura) ,700 gm Beef ,1/2 cup Sour yoghurt ,1 tsp each Ginger-garlic pastes ,1 tbsp Papaya paste,1/2 cup Chopped onion ,15 pcs Green chili,1/2 cup Mustard oil ,2 tbsp Ghee,2 tsp to taste Sugar ,8/10 pcs Raisin ,To taste Salt', 0, 0, 1, 0, 1, 1045.42, 109.18, 55.88, 43.19, 2.32);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Egg Biryani ', 'nan', 5, 20, 60, '5 pcs Boiled eggs,6 pcs Large potato pieces,1 cup Chopped onion,1 tbsp Ginger-garlic pastes ,1/2 packet Ready-made biriyani masala,2 tsp or to taste Sugar,4 pcs Green chilies ,10/12 pcs Raisins ,2 tsp Ghee ,1/2 cup Oil ,2 cups or 500 gm Chinigura/aromatic rice ,To taste Salt', 1, 0, 1, 0, 1, 652.33, 106.7, 17.38, 16.96, 4.41);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Pulao', 'nan', 6, 30, 45, '3 cups Aromatic rice (Kalojeera/Chinigura),1 tsp each Ginger-garlic pastes,2 tbsp Chopped onion,1 pc Bay leaf,3 pcs Cinnamon ,4 pcs Cardamom,4/5 pcs Cloves,7/8 pcs Black pepper,1 cup Hot liquid milk,5 cups Hot water ,1/2 cup Vegetable/soybean oil,3 tbsp,Ghee/clarified butter,4/5 pcs Green chilies,To taste Sugar ,To taste Salt,8/10 pcs Raisin ,As required Crispy fried onion/beresta,As required Boiled peas (optional)', 1, 0, 1, 0, 1, 530.25, 92.85, 9.58, 12.89, 2.67);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Bhapa Pitha', 'nan', 4, 40, 60, '2 cups Rice flour ,1 cup Grated coconut,1 cup Jaggery ,To taste Salt', 1, 1, 0, 1, 0, 442.88, 88.42, 4.49, 8.17, 3.02);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Fried Rice ', 'nan', 4, 30, 30, '1 cup Chinigura/aromatic rice ,200 gm Shrimp,1/2 cup Chopped cabbage,1/2 cup Chopped carrot,1/2 cup Chopped capsicum ,1/2 cup Chopped onion,4-5 pcs Chopped green chilies ,2 tbsp Chopped green onion,1/4 tsp each Ginger-garlic pastes,2 tbsp Vegetable oil/butter,1/2 tsp Black pepper powder,1 tbsp Soy sauce ,2 pcs Egg,To taste Salt,To taste Sugar', 0, 0, 1, 0, 1, 377.14, 47.59, 20.36, 11.55, 2.14);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Chitoi Pitha', 'nan', 6, 30, 30, '1 cup Chinigura/kalijeera rice ,1/2 cup Normal rice,2 tbsp Scraped coconut (optional),1 & 1/2 cups Lukewarm water ,1 tsp Vegetable/soybean oil,1 tsp Water,To taste Salt', 1, 1, 0, 1, 0, 197.45, 40.3, 3.57, 1.95, 0.83);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Vuna Khichuri', 'nan', 6, 15, 45, '500 gm Normal rice,200 gm Chickpea dal,1/2 cup Vegetable/soybean oil,2 tbsp Ghee,1/2 tsp Black cumin (Shahi jeera),2 pcs Bay leaves,4 pcs each Whole cinnamon & cardamom,1/2 cup Chopped onion,1 tbsp each Garlic-ginger pastes,1 tsp Cumin powder,1 tsp Turmeric powder,4-5 pcs Whole green chilies,1 tbsp Dried red chili powder,As required Crispy fried onion/beresta,To taste Salt,4 pcs Cloves,5-6 pcs Black pepper,1/2 tsp Nutmeg-mace paste', 1, 0, 1, 0, 1, 721.42, 96.71, 13.58, 31.59, 8.65);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Zarda', 'nan', 8, 20, 30, '2 cups Aromatic rice (Kalojeera/Chinigura),1 cup Sugar,2 pcs Bay leaves,2 pcs Cinnamon,5-6 pcs Cloves,1/2 tsp Cardamom powder,1/2 cup Ghee,As required Dry fruits (Nuts, raisins etc.),As required Confiture (Morobba),1 tsp Food color (Orange/Egg Yolk)', 1, 0, 1, 0, 1, 460.14, 69.9, 4.31, 18.31, 1.36);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Butter Cookie ', 'nan', 4, 20, 30, '1/2 cup Salted Butter,1/2 cup Powdered sugar,1 pc \Egg yolk,1/2 tsp Vanilla extract,1 cup Wheat flour,2 tbsp Corn flour,2 tbsp Milk powder,1 tsp Baking powder', 1, 1, 0, 1, 0, 433.24, 43.31, 5.14, 26.9, 0.85);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Fulko Luchi', 'nan', 5, 40, 20, '1 cup Flour,1/2 tsp Sugar,To taste Salt,One & half cups/as per requirement Soybean/vegetable oil', 1, 1, 0, 1, 0, 301.46, 18.81, 2.47, 24.24, 0.65);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Chocolate Cake', 'nan', 6, 20, 30, '2 pcs Egg,1 cup Flour,1/4 cup Cocoa powder,1 tbsp Milk powder,1 tsp Baking powder,1/4 tsp Baking soda,3/4 cup Sugar,2 tbsp Oil,1 tsp Vanilla essence,1 tbsp Butter,1/2 cup Liquid milk', 1, 0, 0, 1, 0, 295.92, 45.67, 7.04, 10.89, 2.03);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Shahi Tukra', 'nan', 4, 10, 20, '6 pcs Bread,2 cups Liquid milk,2 tbsp Powder milk,1 tsp Custard powder,1/4 cup Sugar,1/4 tsp Cardamom powder,1/2 cup Ghee,As required Mixed dry nuts', 1, 0, 0, 1, 0, 557.52, 46.43, 10.65, 36.91, 1.64);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Milk Cookies', 'nan', 4, 20, 30, '1 tbsp Butter,2 tbsp Icing sugar,1/4 cup Corn flour,2 tbsp Flour,1/4 cup Milk powder,1/2 tsp Baking powder,2 tsp Liquid milk', 1, 0, 0, 1, 0, 136.11, 20.35, 2.53, 4.91, 0.18);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Milk Bun', 'nan', 4, 150, 25, '1.5 cups Flour,2 tbsp Milk powder,1/2 tbsp Dry yeast,1 tbsp Sugar,1 tsp or to taste Salt,1 pc Beaten egg,1/2 cup Melted butter', 1, 1, 0, 1, 0, 439.77, 39.82, 8.71, 27.59, 1.65);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Cupcake', 'nan', 1, 10, 2, '3 tbsp Wheat flour,2 tbsp Sugar,2 tbsp Vegetable oil/butter,1 tbsp Cocoa powder,3 tbsp Liquid milk,1/4 tsp Baking powder,Just a pinch Baking soda,1 tsp Chocolate chips', 1, 1, 0, 1, 0, 529.27, 58.81, 5.69, 32.72, 3.05);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Paratha', 'nan', 2, 15, 20, '1 cup Wheat flour,1 tbsp Milk powder,1/2 tsp Sugar,To taste Salt,To fry Oil', 1, 1, 0, 1, 0, 351.32, 50.1, 8.28, 12.74, 1.62);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Garlic Bread', 'nan', 4, 120, 20, '1 cup Wheat flour,1 tsp Dry yeast,As required Warm milk or water,2 tbsp Oil,1 tsp Sugar,To taste Salt,1 tbsp Butter,1 tbsp Chopped garlic,2 tbsp Coriander leaves,As required Grated cheese,As required Chili flakes,As required Italian mixed herb', 1, 0, 0, 1, 0, 233.61, 25.62, 4.98, 12.44, 1.34);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Malai Cake', 'nan', 4, 30, 40, '1 cup Wheat flour,3 pcs Eggs,1/2 cup for cake, 1/4 cup for malai Sugar,1/3 cup Oil,1 tsp Baking powder,2 tbsp Powder milk,3 cups Liquid milk,1/4 tsp Cardamom powder,As required Chopped dried nuts & fruits', 1, 0, 0, 1, 0, 334.14, 39.0, 8.55, 15.25, 0.81);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Pizza', 'nan', 4, 20, 30, '1 cup Flour,1 tsp Sugar,1 tsp Instant dry yeast,2 tbsp Oil,To taste Tomato sauce/pizza sauce,As required Grated cheese,As required Capsicum,As required Chopped onion,As required Sausage,As required Mixed herbs,As required Chili flakes,To taste Salt', 0, 0, 0, 1, 0, 243.69, 26.38, 6.54, 12.49, 1.5);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Mughlai Paratha', 'nan', 2, 30, 20, '1 cup Wheat flour,1 pc Egg,1/2 cup Chopped onion,1 tsp Chopped green chili,1 tbsp Coriander leaves,1/2 tsp Roasted cumin powder,To deep fry Oil,To taste Salt', 1, 0, 0, 1, 0, 502.16, 49.32, 10.68, 29.22, 2.28);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Vanilla Cake', 'nan', 4, 20, 50, '1/2 cup All purpose flour,1 tsp Baking powder,2 pcs Egg,1/2 cup Sugar,1/4 cup Oil/ butter,1 tsp Vanilla essence', 1, 0, 0, 1, 0, 334.14, 37.24, 5.45, 18.45, 0.41);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Aloo Paratha', 'nan', 4, 30, 20, '1 and 1/2 cups Wheat flour,1 cup Boiled potato,1 tsp Chopped onion,1 tsp Chopped green chilies,1 pc Roasted/fried dried chili,1 tbsp Chopped coriander leaves,1/2 tsp Roasted cumin powder,1/2 tbsp Roasted coriander powder,1/2 tsp Chat masala powder (optional),To fry Ghee/butter/oil,To taste Salt', 1, 1, 0, 1, 0, 305.64, 45.81, 5.89, 10.76, 2.48);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Egg Pizza Sandwich', 'nan', 2, 10, 10, '1 pc Egg,4 pcs Bread slices,As required Grated cheese,As required Chopped sweet chili/capsicum/tomato/cucumber,As required Chili flakes,As required Oregano-parsley,As required Butter,To taste Salt', 1, 1, 0, 1, 0, 325.67, 32.19, 13.4, 16.07, 2.32);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Banana Cake', 'nan', 4, 30, 60, '2 pcs Well ripen banana,1 cup Wheat flour,2 pcs Egg,1/2 cup Sugar,1/2 cup Oil/butter,1 tsp Baking powder,1/2 tsp Baking soda,1/2 cup Liquid milk,1 tsp Vanilla essence', 1, 0, 0, 1, 0, 453.85, 63.63, 8.66, 19.08, 2.34);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Dal Poori ', 'nan', 6, 30, 15, '1/2 cup Lentil,5 pcs Fried red chili,1 tbsp Chopped coriander leaves (Optional),To taste Salt,1 & 1/2 cups Flour,For deep frying Vegetable/soybean oil,1 tbsp Vegetable/soybean oil,A pinch Turmeric powder,As required Water', 1, 0, 0, 1, 0, 242.1, 26.8, 4.72, 13.0, 2.39);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Egg Sandwich', 'nan', 2, 10, 20, '8 pcs Bread slices,2 pcs Hard boiled eggs,1 tbsp Chopped onion,1/2 tsp Chopped green chilies,2 tbsp Chopped cucumber,1 tbsp Tomato sauce,2 tbsp Mayonnaise,1/4 cup Butter,To taste Salt', 1, 1, 0, 1, 0, 734.0, 61.28, 19.08, 46.07, 3.53);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Chicken Bun', 'nan', 7, 60, 45, '500 gm Boneless minced chicken,1 tsp each Ginger-garlic pastes,1/2 tsp Black pepper powder,1 tsp Soy-sauce,2 tbsp Choped onion,1 tsp Chopped green chilies,1 tsp Tomato sauce,1 tbsp Vegetable/soybean oil,To taste Salt', 0, 0, 0, 1, 0, 193.71, 0.89, 19.65, 11.89, 0.2);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Maltova Cake', 'nan', 6, 30, 45, '3 pcs Egg,3/4 cup Wheat flour,1/2 cup Maltova,1 tsp Baking powder,1/2 cup Sugar,1/2 cup Vegetable/soybean oil,1/2 tsp Vanilla essence,As required Dry fruits (Nuts, raisins, confiture/morobba etc.)', 1, 0, 0, 1, 0, 310.92, 38.71, 6.55, 15.0, 0.78);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Murighonto', 'nan', 6, 30, 40, '1 cup Mung Dal,1 pc Big fish head (Rohu/Katla),2 pcs Bay leaves,5 pcs Cloves,5 pcs Black pepper,1/2 cup Chopped onion,1 tbsp Ginger-garlic pastes,1 tsp Cumin powder,1 tsp Red chili powder,1/4 tsp Cardamom powder,1/2 tsp Cinnamon powder,1/2 tsp,Coriander powder,1 tsp Turmeric powder,To taste Salt,5-6 pcs Green chilies,1/2 cup Cooking oil,1/2 tsp Roasted cinnamon, cardamom & cumin powders', 0, 0, 1, 0, 1, 352.69, 22.92, 15.36, 22.59, 6.54);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Jessore Jolojog Style Dal', 'nan', 6, 30, 40, '1 cup Chick pea or gram,3 tbsp Vegetable/soybean oil,1 pc Potato, cut into small pieces,2 pcs Cinnamon,1 pc Cardamom,4 pcs Dried red chili, cut into half,1 tsp Panch foron (Special 5 spices mix),As required Water,To taste Salt,To taste Sugar,1/2 tsp Ginger paste,1/2 tsp Turmeric powder,1/2 tsp Cumin powder,1 tsp Corn flour,2 pcs Green chili', 1, 0, 1, 0, 1, 153.48, 16.32, 3.75, 8.65, 3.61);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Chotpoti', 'nan', 6, 10, 30, '250 gm Gram,1 tbsp Chopped onion,1/2 tsp Garlic paste,1/2 tsp Ginger paste,1/2 tsp Turmeric powder (optional),1/2 tsp Cumin powder,2 tbsp Vegetable/soybean oil'',1/2 tsp Cinnamon powder,To taste Salt,1/2 tsp Cardamom powder,As per requirement Water,1 pc Potato (medium sized, optional),6-7 pcs Sliced green chilies', 1, 0, 0, 1, 0, 141.44, 17.96, 4.43, 6.25, 4.12);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Mung Dal with Fat', 'nan', 6, 20, 40, '1 cup or 250 gm Mung dal,200 gm Mutton/beef fat,1 pc Potato (Medium size),1 tsp each Ginger-garlic paste,1/3 cup Chopped onions,1/2 tsp Mace-nutmeg paste,1 tsp Cumin powder,1 tsp Turmeric powder,1/2 tsp Cinnamon powder,1/2 tsp Cardamom powder,2 pcs Bay leaves,4/5 pcs Cloves,1/2 tsp Black cumin "Shahi jeera"'',4/5 pcs Green chili,1/3 cup Vegetable/soybean oil,To taste Salt,1/2 tsp Roasted cumin powder,1/2 tsp Roasted cinnamon-cardamom powder (Optional)', 0, 0, 1, 0, 1, 567.79, 32.52, 11.02, 45.64, 8.28);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Moshur Daler Bora', 'nan', 5, 20, 15, '1 cup Lentils,1 cup Chopped onion,1 tbsp Chopped green chili,1 tsp Cumin powder,1/2 tsp Tumeric powder,1 tsp each Ginger-garlic paste,To taste Salt,To fry Vagetable/soybean oil', 1, 0, 1, 1, 1, 119.55, 12.25, 4.25, 6.45, 3.97);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Begun Ghanto', 'nan', 4, 10, 20, '1 pc Brinjal/eggplant/aubergine (Large size),1 pc Potato (Medium size),5-6 pcs Dal Bori (Pellets made locally with dal & ash gourd),2 tbsp Chopped onion,1tsp Chopped garlic,2-3 pcs Dried red chili,3-4 pcs Green chili,1/2 tsp Turmeric powder,1 tsp Cumin,2 tbsp Vegetable oil,2 piece Bay leaves,To taste Salt', 1, 0, 1, 0, 1, 177.41, 23.47, 4.4, 8.56, 6.01);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Dal Khashi Recipe', 'nan', 8, 15, 30, '1 kg Mutton (with bone or boneless),250 gm Mung dal,1/2 cup Chopped onion,1 tbsp Ginger paste,1 tbsp Garlic paste,1 tsp Cumin powder,1 tbsp Dried red chili powder,1 tsp Turmeric powder,1/2 tsp Nutmeg powder,A small pc Mace,4 pcs Clove,3 pcs Bay leaves,1/2 tsp Cinnamon powder,1/2 tsp Cardamom powder,1/2 cup Vegetable/soybean oil,1 tsp Roasted spices powder (Cumin, cinnamon & cardamom),To taste Salt', 0, 0, 1, 0, 1, 574.75, 22.23, 40.04, 36.66, 6.31);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Chicken Chow Mein', 'nan', 2, 20, 15, '2 packets Noodles,100 gm Boneless chicken,As required Vegetables,1/4 tsp Chopped garlic,1 tsp Chopped green chilies,1 tbsp Soy sauce,1 tbsp Tomato ketchup,1 tsp Black pepper powder,2 tbsp Oil,1 tbsp Butter,To taste Sugar (Optional),To taste Salt,1 tbsp Oyster sauce (Optional)', 0, 0, 1, 1, 1, 465.16, 38.26, 22.08, 24.69, 1.84);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Chicken Noodle Soup', 'nan', 4, 10, 20, '2 packets Noodles,1/2 tsp Ginger-garlic paste,1 tbsp Oil/ butter,1 tsp Chopped green chilies,1/2 cup Boneless chicken,1/4 tsp Black pepper powder,1/2 tsp Red chili powder,2 tbsp Tomato sauce,As required Vegetables,To taste Salt', 0, 0, 1, 1, 1, 151.28, 16.37, 8.55, 5.56, 0.54);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Spicy Chicken Fry', 'nan', 4, 120, 30, '400 gm Chicken,1 tsp each Ginger-garlic pastes,1 tsp Black pepper powder,1 & 1/2 tsp Red chili powder,1/2 tsp Chili flakes,1tsp Soy sauce,1/2 tsp Italian mixed herb,1 cup Wheat flour,2 tbsp Corn flour,To fry Oil,To taste Salt', 0, 0, 1, 1, 1, 448.29, 31.99, 34.73, 19.36, 1.98);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Spicy Chicken Spaghetti', 'nan', 4, 30, 20, '250 gm Spaghetti,1/2 cup Minced chicken,2 tbsp Butter,1 tsp Chopped garlic,1/2 tsp Chili flakes,2 tbsp Chopped capsicum/bell pepper,As required Oregano-parsley,1/2 cup Grated cheese,1/2 cup Tomato sauce,1 tsp Soy sauce (dark/light),1 tsp Oyster sauce,1 tsp Cooking oil,To taste Salt,To boil Water', 0, 0, 1, 1, 1, 314.95, 28.76, 17.47, 14.16, 1.62);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Chicken Roast', 'nan', 4, 30, 30, '1 kg Whole chicken,1/2 cup Vegetable oil,2 tbsp Ghee,1/2 cup Chopped onion,2 tbsp Crispy fried onion/beresta (optional),1 tsp Sugar,2 tbsp Powder Milk,To taste Salt,2 pcs Bay leaves,1/2 tbsp Caraway/sha-jeera,6-7 pcs Raisin,3-4 pcs Prunes/alu bokhara'',1/2 cup Sour yogurt,1 and 1/2 tbsp Ginger-garlic pastes,3 tbsp Cashew nut paste,1 tbsp Dried red chili powder,2 sticks Cinnamon (long),6 pcs Cardamom,5-6 pcs Cloves,1/2 tsp Black pepper,1/2 pc Nutmeg,2 pcs Mace,1/2 tsp White pepper', 0, 0, 1, 0, 1, 1085.67, 20.68, 76.06, 77.93, 4.49);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Kathi Kabab', 'nan', 4, 20, 15, '250 gm Boneless beef/mutton/chicken,1 tbsp Onion paste,1 tsp Ginger-garlic pastes,1/2 tsp Cumin powder,1 tsp Red chili powder,1/2 tsp each Cardamom-cinnamon powders,1 tsp Kabab masala,1 tbsp Vegetable/soybean oil,1 tsp Butter,To taste Salt', 0, 0, 1, 1, 1, 213.72, 3.03, 17.64, 13.77, 1.22);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Chicken Curry', 'nan', 6, 20, 40, '600 gm Chicken,4 pcs Potato, medium,2 tbsp Chopped onion,1 tbsp Garlic cloves,1 tbsp Chopped ginger,1 tsp Whole or crushed cumin,1 tsp Turmeric powder,6-7 pcs or to taste Dried red chili,3 pcs Cinnamon,3 pcs Cardamom,4-5 pcs Cloves,2 pcs Bay leaves,2,tbsp Soybean oil,1 tbsp Mustard oil,To taste Salt', 0, 0, 1, 0, 1, 415.24, 24.8, 30.0, 21.78, 3.39);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Chicken Jhal Fry', 'nan', 4, 20, 30, '600 gm Chicken,1 tsp each Ginger-garlic pastes,1 tbsp Red chili powder,1 tsp Cumin powder,1 tsp Turmeric powder,2 pcs Cinnamon,2 pcs Cardamom,2 pcs Cloves,2 pcs Bay leaves,3 tbsp Vegetable/Soybean oil,2 pcs Tomato,To taste Salt,1/3 cup Chopped onion,1/2 tsp Roasted cumin powder', 0, 0, 1, 1, 1, 622.86, 37.2, 45.0, 32.68, 5.09);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Fulkopi Diye Murgir Mangsho', 'nan', 6, 20, 30, '1 pc Cauliflower, medium size,800 gm Chicken,2 pcs Potato,1/2 cup Chopped onion,1 tsp Ginger paste,1/2 tsp Garlic paste,1 tsp Cumin powder,1 pc Bay leaf,2 pcs Cinnamon,2 pcs Cardamom,1 tsp Turmeric powder,1 tsp Dried red chili powder,1 tsp Roasted spices powder (Cinnamon, cardamom & cumin),3 tbsp Vegetable/soybean oil,To taste Salt', 0, 0, 1, 0, 1, 460.65, 16.52, 38.88, 26.28, 3.06);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Mogoj Vuna', 'nan', 4, 20, 20, '400 Beef brain,2 tbsp Chopped onion,1 pc Bay leaf,1/2 tsp Cinnamon powder,1/2 tsp Cardamom powder,1/2 tsp each Ginger-garlic pastes,1 tsp Dried red chili powder,1/2 tsp Turmeric powder,1/4 tsp Black pepper powder,1/2 tsp Cumin powder,3 tbsp Vegetable/soybean oil,3/4 pcs Green chilies,To taste Salt', 0, 0, 1, 0, 1, 259.62, 4.68, 12.89, 21.19, 1.34);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Gorur Matha Vuna', 'nan', 4, 20, 30, '1 pc Cow head, large,1/3 cup Chopped onion,1 tsp each Ginger-garlic pastes,1 tbsp Red chili powder,1 tsp Cumin powder,1 tsp Turmeric powder,3 pcs Cinnamon,4 pcs Cardamom,2 pcs Bay leaves,5-6 pcs Cloves,5-6 pcs Black pepper,1/2 cup Soybean oil,To taste Salt,As required Roasted cumin powder', 0, 0, 1, 0, 1, 853.13, 7.99, 75.96, 58.88, 3.11);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Gorur Mangsho Alu Diye', 'nan', 6, 20, 40, '1 kg Beef,1/2 cup Vegetable oil,1/2 cup chopped onion,1/2 tbsp Garlic paste,1/2 tbsp Ginger paste,2 tsp Dried red chili powder,2 pcs Bay leaves,3-4 pcs Cloves,1/2 tsp Coriander powder,1 tsp Cumin powder,1 tsp Turmeric powder,1/2 tsp Roasted cinnamon powder,1/2 tsp Roasted cardamom powder,1/2 tsp Roasted cumin powder,2 pcs Potatoes (Medium in size),A pinch Turmeric or saffron powder,5-6 pcs Black pepper,2-3 pcs Cinnamon,3-4 pcs Cardamom', 0, 0, 1, 0, 1, 666.02, 16.12, 45.45, 51.68, 3.27);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Handi Kebab', 'nan', 5, 15, 20, '300 gm Beef/mutton,1 tbsp Onion paste,1 tsp each Ginger-garlic paste,2 tbsp Papaya paste,1/2 cup Sour yogurt,1/2 tsp Nutmeg-mace paste'',1 tsp Tomato sauce,1/2 tsp Cardamom powder,1/2 tsp Coriander powder,1 tsp Cumin powder,1 tbsp Red chili powder,4,tbsp Vegetable/Soybean oil,3-4 pcs Cinnamon,3-4 pcs Cloves,2 pcs Bay leaves,To taste Salt', 0, 0, 1, 1, 1, 301.33, 6.99, 18.97, 24.26, 2.25);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Bot Vaja', 'nan', 4, 20, 20, '500 gm Beef tripe,1 pc Potato (Medium size),1/3 cup Chopped onion,1 tsp each Chopped ginger & garlic,4/5 pcs Dried red chili,3/4 pcs Cinnamon,3 pcs Cardamom,1 pc Bay leaf,3/4 pcs Cloves,1 tsp Cumin,1 tsp Turmeric powder,1/2 tsp Red chili powder,2 tbsp Vegetable/soybean oil,To taste Salt', 0, 0, 1, 1, 1, 231.02, 12.86, 16.73, 12.88, 2.69);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Beef Chili', 'nan', 6, 30, 30, '300 gm Beef (Boneless)'',1 cup Broccoli,1/2 cup Capsicum,1/2 cup Onion,2/3 pcs Sliced green chilies,1 tbsp Soy sauce,1 tbsp Tomato sauce,2/3 pcs Dried red chili,1/2 tsp each Ginger-garlic pastes,1/2 tsp Sugar,2 pcs Tomato,1/2 tsp Black pepper
-- 2 tbsp Vegetable/soybean oil,1 tsp Cornflour,To taste Salt,1 tbsp Chopped green onion', 0, 0, 1, 0, 1, 198.11, 6.18, 14.15, 14.53, 1.27);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Khashir Mangsho Alu Diye', 'nan', 6, 15, 45, '1 kg Mutton,4 pcs Potato,1/2 cup Chopped onion,1 tsp each Ginger-garlic paste,1 tsp Cumin powder,1 tbsp Red chili powder,1/2 tsp Mace-nutmeg paate,1 tsp Papaya paste,1 tsp Turmeric powder,As required Roasted spices powder (Cinnamon, cardamom & cumin),1/2 cup Vegetable/soybean oil,To taste Salt,2 pcs Bay leaves,4 pcs Cloves,1/2 tsp each Cinnamon-cardamom powders', 0, 0, 1, 0, 1, 781.3, 25.26, 44.48, 57.04, 3.73);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Ol Diye Ilish Mach', 'nan', 4, 20, 30, '4 pcs Hilsa fish,1 kg Arum,8/10 pcs Green chilies,2 tbsp Chopped onion,1/4 cup Oil,1/2 tsp Turmeric powder,To taste Salt', 0, 0, 1, 0, 1, 560.5, 27.27, 29.25, 38.3, 3.7);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Ilish Lej Vorta', 'nan', 4, 10, 20, '4 pcs Hilsa tail,4/5 pcs Dried red chilies,2 pcs Chopped green chilies,1/4 cup Chopped onion,3 tbsp Mustard oil,To taste Salt', 0, 0, 1, 0, 1, 423.5, 2.88, 25.52, 34.63, 0.91);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Pui Shak Ilish Matha', 'nan', 4, 20, 30, '1 pc Hilsha fish head,500 gm Malabar spinach,2 tbsp Chopped onion,6/7 pcs Green chilies,2 tbsp Oil,1 tsp Turmeric powder,To taste Salt', 0, 0, 1, 0, 1, 252.95, 6.02, 15.0, 19.43, 3.07);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Kachkola Ilisher Jhol', 'nan', 4, 10, 25, '500 gm Green banana,4 pcs Hilsa fish,2 tbsp Chopped onion,5/6 pcs Green chilies,2 tbsp Oil,1 tsp Turmeric powder,To taste Salt', 0, 0, 1, 0, 1, 495.45, 30.27, 26.63, 30.93, 3.7);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Begun Chingri', 'nan', 4, 10, 30, '1 pc (Medium in size) Egg plant,8/10 pcs (Large in size) Prawns,2 tbsp Chopped onion,7/8 pcs Green chilies,1 pc (Medium in size) Potatoes,1 tsp Mustard paste,1 tsp Turmeric powder,2 tbsp Oil,To taste Salt', 0, 0, 1, 0, 1, 185.08, 12.69, 16.19, 8.62, 2.78);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Macher Kabab', 'nan', 6, 20, 20, '4 pcs Fish,150 gm Boiled mashed potato,1 tbsp Fried onion,1 tsp Chopped green chilies,1 tbsp Chopped coriander leaves,1/2 tsp Cumin powder,1/2 tsp Coriander powder,1/2 tsp Garam masala powder,1/2 tsp Red chili powder,1 tsp Ginger-garlic paste,To taste Salt,1/2 Beaten egg,To fry Oil', 0, 0, 1, 1, 1, 219.29, 6.51, 16.51, 13.92, 1.02);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Lau Chingri', 'nan', 4, 10, 20, '1 medium size Bottle gourd,1/2 of a large size Potato,100 gm Prawn,2 tbsp Chopped onion,5/6 pcs Green chilies,To taste Salt,1/2 tsp Turmeric powder,1/2 tsp Cumin powder,2 tbsp Oil', 0, 0, 1, 0, 1, 149.47, 13.43, 7.77, 8.04, 2.55);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Rui Macher Vuna', 'nan', 6, 15, 30, '8 pcs Rohu fish,1 cup Chopped onion,1 tsp each Ginger-garlic pastes,1 tsp Cumin powder,1 tsp Coriander powder,1/2 tsp Cinnamon-cardamom powder,1 tbsp Red chili powder,1 tsp Turmeric powder,1/2 cup Oil,6-7 pcs Green chilies,1 pc Tomato,As required Coriander leaves,To taste Salt,2 pcs Bay leaves', 0, 0, 1, 0, 1, 335.59, 5.9, 26.42, 23.47, 2.0);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Makha Ilish', 'nan', 6, 10, 15, '6 pcs Hilsa fish,1 cup Chopped onion,5/6 pcs Green chilies,3 tbsp Mustard oil,1/2 tsp Turmeric powder,To taste Salt', 0, 0, 1, 0, 1, 386.27, 2.3, 25.29, 30.54, 0.46);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Borboti Chingri Vorta', 'nan', 4, 20, 20, '250 gm Long beans,100 gm Shrimps,2 tbsp Chopped onion,7-8 pcs Green chilies,5-6 pcs Garlic,1/4 tsp Cumin,1 tbsp Mustard oil,1 tbsp Cooking oil,To taste Salt', 0, 0, 1, 0, 1, 131.18, 7.61, 8.18, 8.05, 2.09);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Echor Chingri Recipe', 'nan', 6, 30, 45, '500 gm Raw Jackfruit,200 gm Prawn/shrimp,1/3 cup Chopped onion,1 tsp each Ginger-garlic pastes,1 tsp Cumin powder,1 tsp Red chili powder,1 tsp Turmeric powder,2 Pcs Cinnamon,3 Pcs Cardamom,1 pc Bay leaf,3 Pcs Cloves,1/2 tsp Roasted garam masala powder,1/3 cup Vegetable/soybean oil,To taste Salt,1 tsp Sugar (optional)', 0, 0, 1, 0, 1, 253.0, 24.54, 10.04, 14.63, 4.56);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Mola Chorchori', 'nan', 4, 10, 15, '200 gm Mourala/Mola Fish,2 pcs Potato,1/2 cup Chopped onion,6/7 pcs Green chili slices,2 pcs Tomato slice,2 tbsp Vegetable/soybean oil,1 tbsp Mustard oil,1 tbsp Coriander leaves,To taste Salt,1 tsp Turmeric powder', 0, 0, 1, 0, 1, 227.59, 18.1, 11.17, 12.42, 2.14);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Vapa Ilish', 'nan', 4, 20, 10, '4 pcs Hilsa fish,1 cup Chopped Onions,5/6 pcs Green chilies sliced,1/3 cup Mustard oil,1 tsp Mustard paste,1/2 tsp Turmeric powder,To taste Salt', 0, 0, 1, 0, 1, 508.1, 3.8, 25.77, 43.51, 0.84);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Dharosh Chingri Chorchori', 'nan', 4, 10, 20, '500 gm Okra, cut into 1,1/2 cup Shrimp, medium or small in size,2 tbsp Chopped onions,5-7 pcs Green chilies,1/2 tsp Turmeric powder,To taste Salt,1 tsp Cumin powder,2 tbsp Vegetable/soybean oil', 0, 0, 1, 0, 1, 155.31, 10.73, 11.92, 8.36, 4.44);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Masala Fish Fry', 'nan', 2, 15, 20, '1 pc Any boneless fish like telapia, coral (Whole, 250 gm),1/2 tsp Garlic paste,1/2 tsp Ginger paste,1 pinch Black pepper powder,1 tsp Soya sauce,1/2 tsp Dried red chili powder,1/2 tsp Lemon juice,1 tsp Corn flour,1/3 cup Vegetable/soyabean oil to fry,To taste Salt', 0, 0, 1, 0, 1, 491.44, 3.78, 25.55, 42.33, 0.45);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Rui Machher Kalia', 'nan', 10, 10, 20, '10 pcs Rohu fish,1/2 cup Chopped onion,1 tbsp each Ginger-garlic paste,1 pc Cinnamon,1 pc Cardamom,1 tbsp Cumin powder,1 tsp Coriander powder,1 tbsp Dried red chili powder,1tsp Turmeric powder,1/3 cup Vagetable/Soybean oil,2 pcs Tomato,5/6 pcs Green chili,To taste Salt', 0, 0, 1, 0, 1, 189.22, 4.01, 19.84, 10.71, 1.36);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Palong Chingri', 'nan', 4, 15, 20, '600 gm Spinach,200 gm Shrimps,2 tbsp Chopped onion,4/5 pcs Green chilies,1 tsp Turmeric powder,2 tbsp Vegetable/Soybean oil,To taste Salt', 0, 0, 1, 0, 1, 150.75, 7.0, 15.0, 8.0, 3.45);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Begun Diye Rui Machh', 'nan', 6, 10, 20, '500 gm Eggplant/aubergine/brinjal,5/6 pcs Rohu fish,2 tbsp Chopped onion,5-7 pcs Green chilies,1 tsp Turmeric powder,1 tsp Mustard paste,2 pcs Tomato,2 tbsp Vegetable/soybean oil,To taste Salt', 0, 0, 1, 0, 1, 207.83, 8.15, 24.6, 9.97, 3.3);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Fish Finger', 'nan', 4, 45, 15, '300 gm fBoneless fish,1/2 tsp each Ginger-garlic pastes,1 tsp Soy sauce,1 tsp Red chili powder,Just a pinch Black pepper,1/2 tsp Lemon juice,1 pcs Egg,1/4 cup Wheat flour,1/2 cup Breadcrumb,To deep fry Oil,To taste Salt', 0, 0, 1, 1, 1, 210.0, 17.2, 18.55, 7.15, 0.95);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Shim Shorputir Jhol', 'nan', 6, 20, 30, '500 gm Bean,500 gm Puntius Fish,2 tbsp Chopped onion,5/7 pcs Sliced green chili,1 tsp Turmeric powder,1/2 tsp Mustard paste,2 pcs Tomato,2 tbsp Vegetable/soybean oil,To taste Salt,1 pc Potato (Big, optional)', 0, 0, 1, 0, 1, 203.83, 14.9, 22.94, 6.63, 4.08);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Puishak Chingri', 'nan', 4, 15, 15, '500 gm Malabar spinach,200 gm Small shrimp,2 tbsp Chopped onion,5-6 pcs Sliced green chili,1 tsp Turmeric powder,To taste Salt', 0, 0, 1, 0, 1, 84.75, 7.98, 12.78, 1.13, 2.55);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Parshe Macher Chochchori', 'nan', 4, 10, 15, '7/8 pcs Parshe fish (Mullet),1 pc Potato, medium in size,1/2 cup Chopped onion,6/7 pcs Green chili slices,2 pcs Tomato slices,1 tbsp Coriander leaves (Optional),2 tbsp Mustard oil,1 tsp Turmeric powder,To taste Salt', 0, 0, 1, 0, 1, 266.75, 12.93, 29.35, 13.28, 2.38);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Rui Machher Jhol', 'nan', 4, 15, 30, '2 pcs Potato (medium size),4 pcs Rohu fish,12/15 pcs Kumra Bori (Pellets made locally with dal & ash gourd),½ cup Chopped onion,1 tsp Cumin powder,½ tbsp Red chilli powder,½ tsp Turmeric powder,½ cup Oil,2 pcs Tomato,½ tsp Roasted cumin powder,Salt to taste', 0, 0, 1, 0, 1, 587.75, 37.2, 36.48, 35.15, 5.8);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Sorisha Ilish', 'nan', 4, 30, 15, '4 pcs Hilsa fish,3 tbsp Mustard oil,1 tbsp Mustard paste,1/2 cup Chopped onion,5-6 pcs Green chili slice,2 tsp Turmeric powder,To taste Salt', 0, 0, 1, 0, 1, 417.25, 4.0, 35.35, 28.58, 1.25);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Hilsa Fish Fry', 'nan', 3, 20, 15, '3 pcs Hilsa fish pieces,1/2 tsp Turmeric powder,1/2 tsp Dried red chili powder,1/2 tsp or to taste Salt,1/4 cup Chopped onion,2-3 pcs Sliced Green chili,1 tbsp Vegetable/soyabean oil', 0, 0, 1, 0, 1, 355.5, 2.33, 34.83, 22.33, 0.82);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Egg Salad', 'nan', 2, 10, 10, '2 pcs eggs,1 pc Cucumber,1 pc Tomato,2 tbsp Chopped onion,1 pc Chopped green chili,1 tbsp Chopped coriander leaves,2 tbsp Lemon juice,1 tbsp Olive oil,1 tbsp Mayonnaise,1/2 tbsp Black pepper powder,To taste Salt,1/2 cup Cabbage/Capsicum', 1, 1, 1, 1, 1, 220.0, 12.1, 8.05, 17.0, 2.48);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Crispy Egg Ball', 'nan', 4, 20, 20, '2 pcs Grated boiled eggs,1 tbsp Finely chopped onion,1 tsp Chopped green chilies,1 tsp Chopped coriander leaves,1 tbsp Chopped capsicum,To taste Salt,1/2 tsp Roasted coriander powder,1/2 tsp Roasted cumin powder,1 tbsp Corn flour,1 tbsp Gram flour,1/2 tsp,Red chili powder,A pinch Italian mixed herbs,To fry Oil', 1, 0, 0, 1, 0, 80.5, 4.44, 3.85, 5.47, 0.69);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Dimer Barfi', 'nan', 4, 10, 20, '4 pcs egg,1 cup Liquid milk,1/2 cup Milk powder,1/2 cup Ghee,1 cup Sugar,Just a pinch Salt,1 tbsp Semolina,1/2 tsp Cardamom powder', 1, 0, 0, 1, 0, 618.0, 67.9, 12.88, 34.25, 0.18);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Milk Egg Caramel Pudding ', 'nan', 4, 20, 30, '2 pcs Egg,3/4 cup Sugar,1 cup Milk,1/2 tsp Vanilla essence', 1, 0, 0, 1, 0, 218.63, 41.0, 5.15, 4.48, 0.0);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Dim Alur Curry', 'nan', 6, 15, 30, '4 pcs Egg,2 pcs Potato (Medium size),2 tbsp Chopped onion,1 tsp Garlic paste,1 tsp Dried red chili powder,1 tsp Cumin powder,1 tsp Turmeric powder,1 tsp Sugar,2 tbsp Vegetable/soyabean oil,2 cups Coconut milk,4-5 pcs Green chilies (Optional),To taste Salt,1 pc Bay leaf,2 pcs Cinnamon,1 pc Cardamom', 1, 0, 1, 0, 1, 235.83, 16.92, 6.72, 18.45, 1.82);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Dim Vuna', 'nan', 10, 15, 20, '10 pcs Egg,2 cups Coconut milk,1/2 cup Chopped onion,1 tsp Garlic paste,2 tsp Cumin powder,1 tsp Dried red chili powder,1/2 tsp Turmeric powder,1 pc Cinnamon,1 pc Cardamom,1 pc Bay leaf,4-5 pcs Green chili,3 tbsp Vegetable/Soybean oil,1 tsp Crispy fried onion (beresta, optional),To taste Sugar,To taste Salt', 1, 0, 1, 0, 1, 178.1, 3.38, 7.29, 14.83, 0.57);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Lau Chhechki', 'nan', 5, 15, 15, '1 pc Bottle gourd (Medium size),1/2 cup Chopped onion,1 tbsp Chopped garlic,5-6 pcs Sliced green chili,2 pcs Bay leaf,1 tsp Whole cumin,2 pcs Egg,1 tsp Turmeric powder,3 tbsp Vegetable/soybean oil,To taste Salt', 1, 0, 1, 0, 1, 133.2, 7.92, 3.56, 10.38, 1.22);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Mishti Alur Roshbora', 'nan', 6, 20, 30, '2 large size Sweet potatoes,2 tbsp Milk powder,2 tbsp Semolina,1/4 tsp Baking soda,1 tsp Ghee,2 pcs Cardamom,1 cup Jaggery,2 cups Water,For deep frying Oil', 1, 0, 0, 1, 0, 279.42, 53.87, 2.85, 6.72, 2.23);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Langcha', 'nan', 6, 20, 20, '1 cup Milk powder,1 pc Egg,2 tbsp Semolina,2 tsp Flour,1/2 tsp Baking powder,2 tbsp Ghee,1 and 1/2 cups Sugar,To deep fry Oil,4 cups Water,1 pc Cardamom', 1, 0, 0, 1, 0, 417.67, 70.02, 7.22, 13.88, 0.23);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Dark Chocolate Cake', 'nan', 4, 20, 30, '2 pcs eggs,2/3 cup Sugar,1/4 cup Butter,100 gm Dark chocolate,1/2 cup Flour,1/4 cup Cocoa powder,1/2 tsp baking powder,Just a pinch Salt', 1, 0, 0, 1, 0, 469.75, 60.25, 7.53, 24.1, 5.2);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Coconut Laddu', 'nan', 4, 10, 20, '1 and 1/2 cup Shredded coconut,1 cup Sugarcane jaggery,1/4 tsp Cardamom powder', 1, 0, 0, 1, 0, 350.5, 56.1, 1.88, 15.38, 4.15);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Mishti Doi', 'nan', 4, 10, 20, '3 cups Milk,1/2 cup Sugar,1/2 cup Sour yogurt', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Puli Pitha', 'nan', 6, 30, 20, '1 and 1/2 cup Shreded coconut,1/2 cup Sugar,2 pcs Cinnamon,1 pc Cardamom,1 cup Rice flour,1/2 cup Wheat flour,To deep fry Oil', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Sabudana Halwa', 'nan', 3, 10, 30, '200 gm sago,1/3 cup Sugar,2 tbsp Ghee,6/7 pcs Cashew nuts,2 pcs Cinnamon,2 pcs Cardamom,Just a pinch Food color', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Vanilla Cup Cake', 'nan', 6, 20, 30, '1/2 cup Flour,1/2 cup Sugar,2 tbsp Powder milk,2 pcs Eggs,2 tbsp Oil,1/2 tsp Baking powder,1/2 tsp Vanilla essence', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Rasmalai', 'nan', 4, 20, 15, '1 and 1/2 cup Milk powder,3 cup Liquid milk,1/4 tsp Cardamom powder,1/2 cup Sugar,1/2 tsp Baking powder,1tbsp Ghee,1 pc Egg', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Falooda', 'nan', 4, 15, 40, '1/2 cup Sago,2 cups Milk,1 and 1/2 cup Sugar,2 tsp Agar agar powder,2 tsp Milk powder,As required Food colors', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Chhanar Jilapi', 'nan', 6, 30, 30, '1 and 1/2 liters Liquid milk,5 tsp Flour,2 tsp Milk powder,2 tsp Semolina,1/2 tsp Baking powder,1 tsp Ghee,1/4 tsp Cardamom powder,1 and 1/2 cups Sugar,1 cup Water,To fry Oil,1/2 cup Plain yogurt', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Mohabbat Ka Sharbat', 'nan', 2, 30, 10, 'As required Sago,1/4 cup Sugar,1/4 cup Water,1/2 tsp Rose water,A drop Food color,2 cups Cold liquid milk,As required Watermelon cubes', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Balushai Mishti', 'nan', 4, 15, 30, '1 and 1/2 cup Flour,1/4 cup Ghee,1/2 tsp Baking powder,1 cup Sugar,1 pc Cardamom,To fry Oil', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Dudh Semai', 'nan', 4, 10, 30, '200 gm Vermicelli,1 liter Liquid milk,As required Dry nuts & raisins,2 tbsp Ghee,1/2 cup Sugar
-- 1/2 tsp Cinnamon-cardamom powder,Just a pinch Salt', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Roshogolla', 'nan', 5, 40, 50, '1 and 1/2 liter Full cream liquid milk,1/2 cup Yogurt,1 cup Sugar,1 tsp Milk powder,2 tbsp Flour,Just a pinch Cardamom powder', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Nolen Gurer Payesh', 'nan', 6, 10, 20, '1/3 cup Aromatic rice (Kalojeera/Chinigura),1 liter Milk,1/2 cup New jaggery,2 pcs Cinnamon,2 pcs Cardamom,4-5 pcs Raisin,Just a pinch Salt (Optional)', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Thai Soup', 'nan', 6, 10, 20, '1 pc Egg,1/4 cup Tomato ketchup,1/4 cup Red chili sauce,1 tsp Black pepper powder,2 tsp Sugar,3 tbsp Corn flour,1 tbsp Butter,100 gm Chicken,100 gm Prawn,100 gm Mushroom,3 sticks Lemon grass,30 gm Thai ginger/ginger slice,1/2 tsp Chopped Garlic,1 tsp Soy sauce,1 tsp Oyster sauce,1 tbsp Red chili paste,2 tbsp Lemon juice,2 tsp Salt,As required Chopped coriander leaves', 0, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Potato Cheese Balls', 'nan', 4, 15, 20, '1 cup Boiled potato,1 tbsp Chopped onion,1/2 tsp Chopped green chilies,1 tbsp Chopped coriander leaves,1/4 tsp Chili flakes,1/4 tsp Black pepper powder,2 tbsp Grated cheese,1/4 tsp Italian mixed herbs,To taste or 1 tsp Salt,To deep fry Oil', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Muri Vaja', 'nan', 4, 10, 15, '2 cups Puffed rice,1 tbsp Chopped onion,1/2 tsp Chopped garlic,2 tbsp Mustard oil,1/2 tsp Chopped ginger,1/4 tsp Turmeric powder,Just a pinch/ 1 pcs Salt,1/2 tsp Chopped green chilies', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Sujir Biscuit Pitha', 'nan', 4, 10, 20, '1 cup Semolina,2 tbsp Milk powder,1/2 cup Sugar,1/4 tsp Salt,1 tsp Ghee,To fry Oil', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Piyaji', 'nan', 4, 150, 30, '1 cup Mixed dals,1 cup Chopped onion,2 tbsp Chopped green chilies,To taste Salt,1/2 tsp Turmeric powder,To fry Oil', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Chinese Vegetables', 'nan', 4, 10, 30, '500 gm Vegetables (Broccoli. Chinese cabbage & bok choy),1/2 tsp Chopped Garlic,2/3 pcs Dried red chili,3/4 pcs Chopped green chilies,1/2 cup Chopped onion,2 tbsp Oil,1/2 tsp Black pepper powder,To taste Salt,2 tbsp Corn flour,To taste Sugar', 1, 0, 1, 0, 1, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Masala Dudh Cha', 'nan', 2, 5, 10, '1 Cup Cow milk,1 tbsp Tea,1 tbsp or to taste Sugar,1 pc Cardamom,2 pcs Cloves,2 pcs Cinnamon,2 pcs Black pepper,1 cup Water,2 slice Ginger,1 pc Bay leaf', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Alu Pakora', 'nan', 4, 15, 20, '1 cup Finely chopped potato,2 tbsp Chopped onion,1 tsp Chopped green chili,1/2 tsp Ginger paste,1/4 tsp Roasted cumin powder,1/4 tsp Roasted coriander powder,1 tsp Chopped coriander leaves,3 tsp+1 tsp Gram flour,To taste Salt', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Alur Chop', 'nan', 6, 30, 30, '1 and 1/2 cup Gram flour,3 tbsp Rice flour,1 tbsp Corn flour,1 tsp Ginger-garlic paste,1/2 tsp Roasted cumin powder,1 tsp Roasted coriander powder,1 tsp Red chili powder,To taste Salt', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Hot Tomato Ketchup', 'nan', 6, 15, 45, '1 kg Tomato,1 tbsp Chopped onion,3 cloves Garlic,1 tsp or to taste Sugar,To taste Salt,1 tsp Red chili powder,1/4 tsp Cinnamon powder,1/4 tsp Cloves powder,2 tbsp Vinegar,1 tsp Corn flour', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Badhakopir Pakora', 'nan', 4, 15, 15, '1 cup Finely chopped cabbage,1/2 cup Grated carrots,2 tbsp Chopped onion,1 tbsp Chopped green chilies,2 tbsp Chopped coriander leaves,1/2 tsp each Ginger-garlic pastes,1/2 tbsp Roasted cumin powder,1/2 tsp Roasted coriander powder,1 tbsp Corn flour,1/2 cup Gram flour,To taste Salt,1/2 tsp each Oregano-parsley (optional),To deep fry Vegetable/soybean oil', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Crispy Beguni', 'nan', 6, 20, 20, '1 pc Brinjal/eggplant/aubergine,1 cup Gram flour,1 tbsp Rice flour,1 tbsp Corn flour,1/2 tsp Ginger paste,1/2 tsp Garlic paste,1/2 tsp Roasted cumin powder,1/2 tsp Roasted coriander powder,1 tsp Dried red chili powder,To deep fry Vegetable oil,To taste Salt,1 tsp Vegetable oil', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Chinese Vegetable with Chicken', 'nan', 4, 20, 20, '1/2 cup Boneless chicken,1/4 tsp Ginger paste,1/4 tsp Garlic paste,1 & 1/2 tsp Soy sauce,3/4 tsp Black pepper powder,1 cup Sliced carrot,1 cup Cauliflower pieces,1 & 1/2 cup Chopped cabbage,3 tbsp Vegetable/soybean oil,1 pc Egg,1 tsp Tomato sauce,2 pcs Onion, cube-cut,4-5 pcs Green chili, chopped,2 tbsp Corn flour,As per requirement Water,To taste Salt,To taste Sugar, optional,As per requirement Chopped spring onion, optional', 0, 0, 1, 0, 1, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Vegetable Egg Noodles', 'nan', 2, 15, 30, '250 gm Stick noodles,2 pcs Egg,1/2 cup Chopped carrot,1/2 cup Chopped cauliflower,1/2 cup Chopped cabbage,1/3 cup Chopped bean,1/3 cup Chopped onion,2-3 pcs Sliced or chopped green chilies,1 tsp Minced garlic,3 tbsp Vegetable/Soybean oil,1/2 tsp Crushed black pepper or powder,1 tsp Ajinomoto/tasting salt (optional),1 tbsp Soy sauce,To taste Salt,1 tsp Sugar (optionanl)', 1, 1, 1, 1, 1, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Mix Veg', 'nan', 4, 15, 20, '500 gm Seasonal mixed vegetables,1 tsp Special spices mix (Panch foron),2 pcs Bay leaves,2 pcs Cardamom,3 pcs Cinnamon,3 pcs Green chili,4 pcs Dried red chili,1/2 tsp Cumin powder,1/2 tsp Turmeric powder,1/2 tso Ginger paste,1 tsp Sugar,1/2 tbsp Corn flower,3 tbsp Vegetable/Soybean oil,To taste Salt', 1, 1, 1, 1, 1, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Kacha Aam Vorta', 'nan', 4, 15, 10, '2 pcs Green mango,1 tsp Whole Mustard,2/3 pcs Green chilli,To taste Salt,To taste Sugar,1/2 pcs Dried red chili,To taste Black salt', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Fulkopir Pakora', 'nan', 6, 15, 15, '1 pc Cauliflower, medium size,1 cup Gram flour,1 tbsp Corn flour,1 tsp Ginger paste,1/2 tsp Garlic paste,1/2 tsp Cumin powder,1/2 tsp Roasted coriander powder,1 tsp Dried red chili powder,To taste Salt,To deep fry Vegetable/soybean oil', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Jhura Nimki', 'nan', 6, 20, 30, '1 cup Wheat flour,1 tbsp Vegetable/soybean oil,1 tsp Black cumin,1/2 tsp Dried red chili powder,2 cups Vegetable/soybean oil to fry,As per requirement Water,To taste Salt', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Fulcopir Data', 'nan', 4, 15, 30, '200 gm Cauliflower stem,1 pc Brinjal,1 pc Raw banana,1 pc Potato,1/2 cup Pumpkin,1 tbsp Chopped onion,1 tsp Chopped garlic,1 tsp Cumin,2 pcs Red chili,4/5 pcs Green chili,1 pc Bay leaf,1 tsp Turmeric powder,2 tbsp Oil,To taste Salt,4/5 pcs Bori', 1, 0, 1, 0, 1, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Cholar Ghugni', 'nan', 4, 10, 40, '500 gm Chickpeas,1/2 cup Chopped onion,4/5 pcs Garlic cloves,6/7 pcs Green chilies,1 tsp Turmeric powder,1/2 cup Oil,To taste Salt,1 medium in size Potato', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Sauteed Butter Garlic Mushrooms', 'nan', 3, 10, 10, '1 can Canned mushroom,2 tbsp Butter,2 tsp Chopped garlic,1/2 tsp Chili flakes,1/2 cup Chopped onion,1/2 tsp Soy sauce,1 tsp Tomato sauce,1/4 tsp Black pepper powder,Just a pinch/to taste Salt,1/2 tsp Lemon juice', 1, 0, 1, 1, 1, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Alur Dom', 'nan', 4, 10, 30, '2 pcs (medium in size) Potatoes,1 tsp Chopped onion,5-6 pcs Green chilies,1/2 tsp Turmeric powder,To taste Salt,2 tbsp Oil', 1, 1, 1, 1, 1, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Spicy Kashmiri Achar', 'nan', 4, 10, 25, '2 pcs (medium in size) Green mango,1 cup Sugar,1/2 cup Vinegar,1 tbsp Ginger slices,1/2 tbsp Chopped dried red chilies,2 pcs Cinnamon,2 pcs Cardamom,3 pcs Cloves,To taste Salt,1 pc Bay leaf', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Mug Dal Pepe Ghonto', 'nan', 4, 10, 20, '1 cup Chopped papaya,1/2 cup Mung dal,2 tbsp Chopped onion,2 tbsp Chopped garlic,2 pcs Green chilies,1 pc Red chili,1/2 tsp Turmeric powder,2 tbsp Oil,To taste Salt,1/2 tsp Whole cumin', 1, 0, 1, 0, 1, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Kochu Shak Ghonto', 'nan', 4, 30, 30, '2 pcs Taro stem,1/2 cup Mashed prawns,2 tbsp Chopped onion,1 tbsp Chopped garlic,8-10 pcs Green chilies,2 pcs Bay leaves,1 tsp Turmeric powder,1/2 tsp Mustard paste,3 tbsp Oil,To taste Salt', 1, 0, 1, 0, 1, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Amer Achar', 'nan', 6, 20, 30, '1 kg Green mango,1 tsp each Ginger-garlic paste,250 gm Mustard oil,2 pcs Dried red chili,2 pcs Bay leaves,1/4 tsp Whole mustard,2 tbsp or as to taste Sugar,2 tsp Vinegar,To taste Salt,1 tsp Turmeric powder', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Kacha Amer Shorbot', 'nan', 4, 10, 10, '1 pc (large) Green mango,1 tsp or to taste Black salt/salt,1/2 tsp Roasted cumin powder,1 pc Roasted red chili,2 pcs or to taste Green chili,5/6 pcs Ice cube,2 tbsp or to taste Sugar,4 cups Water', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Sojne Data', 'nan', 6, 10, 25, '250 gm Drumstick,1 pc Potato (Medium size),2 tbsp Chopped onion,1 tsp Dried red chili powder,1 tsp Mustard paste,1/2 tsp Cumin powder,1 tsp Turmeric powder,2 pcs Tomato,2 tbsp Vegetable/soybean oil,To taste Salt', 1, 0, 1, 0, 1, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Dhoniya Pata Jolpai Vorta', 'nan', 4, 15, 15, '200 gm Cilantro/coriander leaves,1 pc Fresh olive pieces without seed,4 pcs/to taste Dried red chili,2 pcs/to taste Green chili,2 pcs Onion, medium, cube-cut,4 pcs Garlic cloves, large,1 tbsp Mustard oil,1/2 tsp Cumin powder, optional,To taste Salt', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Jolpai Achar', 'nan', 2, 15, 30, '1/2 kg Olive,1 cup Mustard oil,1 tsp Whole punch foron (Five spices mix),1/2 tsp Ginger paste,1/2 tsp Garlic paste,1 tsp Roasted cumin powder,1/2 tsp Whole mustard,2 tbsp Jaggery/sugar,1 tbsp Vinegar,1 tsp Turmeric powder,2 pcs Bay leaves,5-6 pcs Dried red chilies,1/2 tsp Roasted punch foron powder,To taste Chili powder,To taste Salt', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Kanchkolar Chop', 'nan', 4, 10, 30, '4 pcs Green banana,1/2 tsp each Ginger-garlic pastes,2 tbsp Fried onion,1 tsp Chopped green chilies,1/2 tsp Roasted coriander powder,1/2 tsp Cumin powder,Just a pinch Cardamom powder,As required Chopped coriander leaves,To taste Salt,2 tbsp Cornflour,To shallow fry Vegetable/soybean oil', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Oler Data Kathal Bichi', 'nan', 4, 15, 20, '5-6 pcs Elephant arum stem,250 gm Jack fruit seeds,6-7 pcs Sliced green chilies,2 tbsp Chopped onion,2 pcs Cinnamon,2 pcs Cardamom,1 tsp Mustard paste,1/2 tsp Cumin powder,1/2 tsp each Ginger-garlic paste,1 tsp Turmeric powder,1/4 cup Vagetable/soybean Oil,To taste Salt,1 pc Bay leaf', 1, 0, 1, 0, 1, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Kacha Aamer Chutney', 'nan', 6, 20, 20, '2 pcs Green mango, big size,1/2 cup Jaggery,1/2 cup Mustard oil,1/2 tsp Ginger paste,1/2 tsp Garlic paste,2 tsp Roasted Five spices mix (Panch foron) powder,1 tsp Roasted cumin powder,1 tsp Roasted coriander powder,To taste Salt,1 tbsp Vinegar,1 tsp Dried red chili powder', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Boroi Chutney', 'nan', 4, 15, 25, '500 gm Dried plum,1 cup Sugercane jaggery,1 tbsp Punch foron (Five spices mix),1 tsp Dried red chili powder,To taste Salt', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Tetuler Shorbot', 'nan', 4, 15, 10, '150 gm Tamarind,To taste Black salt,As required Roasted cumin powder,As required Red chili powder,To taste Sugar/jaggery,To taste Salt,As required Roasted coriander powder,4 cups Water', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    

--     INSERT INTO recipes (name, image, serving_size, prep_time_in_mins, cook_time_in_mins, ingredients, is_vegetarian, is_breakfast, is_lunch, is_snack, is_dinner, energy_per_serving_kcal, carbohydrate_g, protein_g, fat_g, fiber_g)
--     VALUES 
--     ('Pineapple Juice', 'nan', 2, 10, 10, '2 cups Pineapple slice,2 tbsp Sugar,2 pcs Green chilies,1 tsp or to taste Black salt,3 cup Water,As required Ice', 1, 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL);
    
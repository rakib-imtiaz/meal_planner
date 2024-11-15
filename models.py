from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime

db = SQLAlchemy()

# User Model
class User(db.Model):
    __tablename__ = 'user'

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), unique=True, nullable=False)
    email = db.Column(db.String(100), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)
    name = db.Column(db.String(100))
    age = db.Column(db.Integer)
    sex = db.Column(db.String(10))
    weight = db.Column(db.Float)
    height = db.Column(db.Float)
    activity_level = db.Column(db.String(20))
    goal = db.Column(db.String(20))
    dietary_restrictions = db.Column(db.String(255))
    created_at = db.Column(db.TIMESTAMP, server_default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, server_default=db.func.current_timestamp(), onupdate=db.func.current_timestamp())

    favorite_recipes = db.relationship('UserFavorite', backref='user', lazy='dynamic', cascade="all, delete-orphan")
    ratings = db.relationship('UserRating', backref='user', lazy='dynamic', cascade="all, delete-orphan")
    dietary_preferences = db.relationship('UserDietaryPreference', backref='user', lazy='dynamic', cascade="all, delete-orphan")

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

# Recipe Model
class Recipe(db.Model):
    __tablename__ = 'recipe'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(120), nullable=False)
    image = db.Column(db.String(255))
    serving_size = db.Column(db.Integer, default=1)
    prep_time_in_mins = db.Column(db.Integer, default=0)
    cook_time_in_mins = db.Column(db.Integer, default=0)
    ingredients = db.Column(db.Text, default='')
    ingredients_name = db.Column(db.Text, default='')
    ingredients_quantity_gram = db.Column(db.Text, default='')
    is_vegetarian = db.Column(db.Boolean, default=False)
    is_breakfast = db.Column(db.Boolean, default=False)
    is_lunch = db.Column(db.Boolean, default=False)
    is_snack = db.Column(db.Boolean, default=False)
    is_dinner = db.Column(db.Boolean, default=False)
    energy_per_serving_kcal = db.Column(db.Float, default=0.0)
    carbohydrate_per_serving_g = db.Column(db.Float, default=0.0)
    protein_per_serving_g = db.Column(db.Float, default=0.0)
    fat_per_serving_g = db.Column(db.Float, default=0.0)
    fiber_per_serving_g = db.Column(db.Float, default=0.0)
    instructions = db.Column(db.Text, default='')
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    ratings = db.relationship('UserRating', backref='recipe', lazy='dynamic', cascade="all, delete-orphan")
    tags = db.relationship('RecipeTag', backref='recipe', lazy='dynamic', cascade="all, delete-orphan")

# User Favorite Model
class UserFavorite(db.Model):
    __tablename__ = 'user_favorite'

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    recipe_id = db.Column(db.Integer, db.ForeignKey('recipe.id'), nullable=False)
    created_at = db.Column(db.TIMESTAMP, server_default=db.func.current_timestamp())
    recipe = db.relationship('Recipe')
    __table_args__ = (db.UniqueConstraint('user_id', 'recipe_id'),)

# User Rating Model
class UserRating(db.Model):
    __tablename__ = 'user_rating'

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    recipe_id = db.Column(db.Integer, db.ForeignKey('recipe.id'), nullable=False)
    rating = db.Column(db.Integer, nullable=False)
    comment = db.Column(db.Text)
    created_at = db.Column(db.TIMESTAMP, server_default=db.func.current_timestamp())
    updated_at = db.Column(db.TIMESTAMP, server_default=db.func.current_timestamp
    (), onupdate=db.func.current_timestamp())
    __table_args__ = (db.UniqueConstraint('user_id', 'recipe_id'),
                      db.CheckConstraint('rating >= 1 AND rating <= 5'))

# Tag Model
class Tag(db.Model):
    __tablename__ = 'tag'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), unique=True, nullable=False)

# Recipe Tag Model
class RecipeTag(db.Model):
    __tablename__ = 'recipe_tag'

    id = db.Column(db.Integer, primary_key=True)
    recipe_id = db.Column(db.Integer, db.ForeignKey('recipe.id'), nullable=False)
    tag_id = db.Column(db.Integer, db.ForeignKey('tag.id'), nullable=False)
    __table_args__ = (db.UniqueConstraint('recipe_id', 'tag_id'),)

# User Dietary Preference Model
class UserDietaryPreference(db.Model):
    __tablename__ = 'user_dietary_preference'

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    preference = db.Column(db.String(50), nullable=False)
    __table_args__ = (db.UniqueConstraint('user_id', 'preference'),)

# Add Admin model
class Admin(db.Model):
    __tablename__ = 'admins'
    
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password = db.Column(db.String(120), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    def __repr__(self):
        return f'<Admin {self.username}>'

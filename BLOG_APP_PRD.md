# Blog App API - Product Requirements Document (PRD)

## 1. Project Overview

### 1.1 Project Name

Blog App API

### 1.2 Project Description

A RESTful API for a blog application built with Ruby on Rails 8.0.2. The application allows users to create, manage, and interact with blog posts. The API is designed to be consumed by frontend applications, mobile apps, or other services.

### 1.3 Technology Stack

- **Framework**: Ruby on Rails 8.0.2
- **Database**: SQLite3 (development), PostgreSQL (production recommended)
- **API Format**: JSON
- **Authentication**: JWT (JSON Web Tokens)
- **Server**: Puma
- **Deployment**: Docker with Kamal

## 2. Core Entities

### 2.1 User Entity

**Purpose**: Represents a user who can create and manage blog posts.

**Attributes**:

- `id` (Primary Key)
- `email` (String, unique, required)
- `username` (String, unique, required)
- `password_digest` (String, required)
- `first_name` (String, optional)
- `last_name` (String, optional)
- `bio` (Text, optional)
- `avatar_url` (String, optional)
- `created_at` (DateTime)
- `updated_at` (DateTime)

**Relationships**:

- Has many posts (one-to-many)

### 2.2 Post Entity

**Purpose**: Represents a blog post created by a user.

**Attributes**:

- `id` (Primary Key)
- `title` (String, required)
- `content` (Text, required)
- `excerpt` (Text, optional)
- `slug` (String, unique, required)
- `status` (String, enum: draft, published, archived)
- `published_at` (DateTime, optional)
- `user_id` (Foreign Key, required)
- `created_at` (DateTime)
- `updated_at` (DateTime)

**Relationships**:

- Belongs to user (many-to-one)

## 3. Database Schema

### 3.1 Users Table

```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email VARCHAR NOT NULL UNIQUE,
  username VARCHAR NOT NULL UNIQUE,
  password_digest VARCHAR NOT NULL,
  first_name VARCHAR,
  last_name VARCHAR,
  bio TEXT,
  avatar_url VARCHAR,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL
);
```

### 3.2 Posts Table

```sql
CREATE TABLE posts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title VARCHAR NOT NULL,
  content TEXT NOT NULL,
  excerpt TEXT,
  slug VARCHAR NOT NULL UNIQUE,
  status VARCHAR DEFAULT 'draft',
  published_at DATETIME,
  user_id INTEGER NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
```

## 4. Rails Commands for Setup

### 4.1 Generate User Model

```bash
rails generate model User email:string:uniq username:string:uniq password_digest:string first_name:string last_name:string bio:text avatar_url:string
```

### 4.2 Generate Post Model

```bash
rails generate model Post title:string content:text excerpt:text slug:string:uniq status:string published_at:datetime user:references
```

### 4.3 Generate Controllers

```bash
# Generate API controllers
rails generate controller Api::V1::Users --skip-template-engine --skip-helper --skip-assets
rails generate controller Api::V1::Posts --skip-template-engine --skip-helper --skip-assets
rails generate controller Api::V1::Auth --skip-template-engine --skip-helper --skip-assets
```

### 4.4 Generate Serializers (Optional - for JSON formatting)

```bash
rails generate serializer User
rails generate serializer Post
```

## 5. API Endpoints

### 5.1 Authentication Endpoints

```
POST   /api/v1/auth/register    # User registration
POST   /api/v1/auth/login       # User login
POST   /api/v1/auth/logout      # User logout
GET    /api/v1/auth/me          # Get current user
```

### 5.2 User Endpoints

```
GET    /api/v1/users            # List all users (public)
GET    /api/v1/users/:id        # Get specific user (public)
PUT    /api/v1/users/:id        # Update user (authenticated, own profile)
DELETE /api/v1/users/:id        # Delete user (authenticated, own profile)
GET    /api/v1/users/:id/posts  # Get user's posts (public)
```

### 5.3 Post Endpoints

```
GET    /api/v1/posts            # List all published posts (public)
GET    /api/v1/posts/:id        # Get specific post (public)
POST   /api/v1/posts            # Create new post (authenticated)
PUT    /api/v1/posts/:id        # Update post (authenticated, own post)
DELETE /api/v1/posts/:id        # Delete post (authenticated, own post)
GET    /api/v1/posts/draft      # Get user's draft posts (authenticated)
```

## 6. API Response Format

### 6.1 Success Response

```json
{
  "status": "success",
  "data": {
    // Response data
  },
  "message": "Optional success message"
}
```

### 6.2 Error Response

```json
{
  "status": "error",
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable error message",
    "details": {
      // Additional error details
    }
  }
}
```

## 7. Authentication & Authorization

### 7.1 JWT Implementation

- Use JWT tokens for stateless authentication
- Token expiration: 24 hours
- Refresh token mechanism for extended sessions

### 7.2 Authorization Rules

- Users can only modify their own posts
- Users can only modify their own profile
- Public read access for published posts
- Draft posts are only visible to the author

## 8. Validation Rules

### 8.1 User Validations

- Email: Required, unique, valid email format
- Username: Required, unique, 3-30 characters, alphanumeric + underscore
- Password: Required, minimum 8 characters, must include uppercase, lowercase, number
- First/Last name: Optional, maximum 50 characters each

### 8.2 Post Validations

- Title: Required, 3-200 characters
- Content: Required, minimum 10 characters
- Slug: Required, unique, URL-friendly format
- Status: Must be one of: draft, published, archived
- User: Required (belongs to user)

## 9. Search & Filtering

### 9.1 Post Search

- Search by title and content
- Filter by status (published, draft, archived)
- Filter by user
- Sort by created_at, updated_at, published_at
- Pagination support

### 9.2 User Search

- Search by username, first_name, last_name
- Filter by post count
- Sort by created_at, username

## 10. Performance Considerations

### 10.1 Database Optimization

- Add indexes on frequently queried columns
- Use counter_cache for post counts
- Implement database-level constraints

### 10.2 API Optimization

- Implement pagination (default: 20 items per page)
- Use includes to prevent N+1 queries
- Add caching for frequently accessed data
- Implement rate limiting

## 11. Security Requirements

### 11.1 Data Protection

- Hash passwords using bcrypt
- Sanitize user inputs
- Implement CSRF protection
- Use HTTPS in production

### 11.2 API Security

- Rate limiting on authentication endpoints
- Input validation and sanitization
- SQL injection prevention
- XSS protection

## 12. Testing Strategy

### 12.1 Test Coverage

- Unit tests for models (validations, associations)
- Controller tests for all endpoints
- Integration tests for authentication flow
- API endpoint tests

### 12.2 Test Commands

```bash
# Run all tests
rails test

# Run specific test files
rails test test/models/user_test.rb
rails test test/controllers/api/v1/posts_controller_test.rb

# Run with coverage
COVERAGE=true rails test
```

## 13. Deployment & DevOps

### 13.1 Environment Setup

- Development: SQLite3
- Production: PostgreSQL
- Environment-specific configurations

### 13.2 Docker Deployment

- Multi-stage Dockerfile
- Kamal deployment configuration
- Environment variable management

## 14. Monitoring & Logging

### 14.1 Application Monitoring

- Request/response logging
- Error tracking and alerting
- Performance monitoring
- Database query monitoring

### 14.2 Health Checks

- Database connectivity
- External service dependencies
- Application status endpoint

## 15. Future Enhancements

### 15.1 Phase 2 Features

- Comments system
- Post categories/tags
- User following system
- Post likes/reactions
- Image upload support
- RSS feeds
- Search with Elasticsearch

### 15.2 Phase 3 Features

- Real-time notifications
- Post scheduling
- Analytics dashboard
- API versioning
- Webhook support

## 16. Success Metrics

### 16.1 Technical Metrics

- API response time < 200ms
- 99.9% uptime
- Zero security vulnerabilities
- 90%+ test coverage

### 16.2 Business Metrics

- User registration rate
- Post creation frequency
- API usage statistics
- Error rate monitoring

---

**Document Version**: 1.0  
**Last Updated**: [Current Date]  
**Author**: Development Team  
**Reviewers**: [To be assigned]

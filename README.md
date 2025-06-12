# GCloud - File Storage Application

GCloud is a Ruby on Rails application that provides secure, user-based file storage and management capabilities. It allows users to organize files in folders, preview different file types, and manage their digital content efficiently. This was made purely out of fun and to help improve my Rails and System Design skills.

## Technologies Used

### Backend
- **Ruby on Rails 8**: Modern web application framework
- **PostgreSQL**: Primary database
- **Active Storage**: File handling and storage
- **Devise**: Authentication system
- **Database Cleaner**: Maintains test database consistency

### Frontend
- **Hotwire (Turbo & Stimulus)**: Modern frontend architecture
- **TailwindCSS**: Utility-first CSS framework
- **Heroicons**: SVG icon system

### Testing
- **RSpec**: Testing framework
- **FactoryBot**: Test data generation
- **Capybara**: System testing
- **SimpleCov**: Test coverage reporting (100% coverage)

## Features

- User authentication and authorization
- Hierarchical folder structure
- File upload and management
- File type-based preview system (images, PDFs, video, audio)
- Breadcrumb navigation
- Modern, responsive UI

## Setup

### Prerequisites

- Ruby 3.2.0 or higher
- PostgreSQL 12 or higher
- Node.js 16 or higher
- Yarn

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/gcloud.git
   cd gcloud
   ```

2. Install dependencies:
   ```bash
   bundle install
   yarn install
   ```

3. Setup database:
   ```bash
   rails db:create db:migrate
   ```

4. Start the server:
   ```bash
   bin/dev
   ```

The application will be available at `http://localhost:3000`

## Testing

The application uses RSpec for testing. To run the test suite:

```bash
bundle exec rspec
```

The test suite includes:
- Model specs with thorough validation and callback testing
- Controller specs for action verification
- System tests for end-to-end functionality
- Helper specs for view helpers

## Architecture

### Models
- **User**: Handles authentication and user management
- **Folder**: Manages folder hierarchy and organization
- **FileEntry**: Handles file metadata and storage

### Security
- Secure user authentication with Devise
- File access control based on user ownership
- Secure file storage with Active Storage
- CSRF protection
- Strong parameters

## Development Practices

- Test-Driven Development (TDD)
- Continuous Integration ready
- 100% test coverage
- RESTful architecture
- Modular and maintainable code structure
- Comprehensive documentation

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE.md file for details

.PHONY: pre-commit format analyze test clean

# Pre-commit checks
pre-commit: format analyze
	@echo "🎉 All pre-commit checks passed!"

# Format code
format:
	@echo "Running dart format..."
	@dart format --set-exit-if-changed .
	@echo "✅ Code formatting is correct"

# Analyze code
analyze:
	@echo "Running flutter analyze..."
	@flutter analyze
	@echo "✅ Code analysis passed"

# Run tests
test:
	@echo "Running tests..."
	@flutter test
	@echo "✅ Tests passed"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@flutter clean
	@echo "✅ Clean completed"

# Install dependencies
deps:
	@echo "Getting dependencies..."
	@flutter pub get
	@echo "✅ Dependencies installed"

# Build for all platforms
build: deps
	@echo "Building for all platforms..."
	@flutter build apk --release
	@flutter build ios --release --no-codesign
	@flutter build web --release
	@echo "✅ Build completed" 
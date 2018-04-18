package main

import (
	"net/http"
	"net/http/httptest"
	"os"
	"testing"
)

func TestHandler(t *testing.T) {
	// Create an http request
	req, _ := http.NewRequest("GET", "/", nil)

	// Create  http.ResponseWriter for test inspection
	w := httptest.NewRecorder()

	// Call the handler
	handler(w, req)

	// Inspect the http.ResponseWriter
	if w.Code != http.StatusOK {
		t.Errorf("Server did not return %v", http.StatusOK)
	}

	if w.Body.String() != "Hello world!" {
		t.Errorf("Body contain \"%v\" instead of expected \"Hello world!\"", w.Body.String())
	}
}

func TestMain(m *testing.M) {
	os.Exit(m.Run())
}

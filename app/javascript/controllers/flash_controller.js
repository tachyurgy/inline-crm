import { Controller } from "@hotwired/stimulus"

// Auto-dismisses flash messages after a delay
export default class extends Controller {
  connect() {
    this.timeout = setTimeout(() => {
      this.element.style.transition = "opacity 0.5s ease-out"
      this.element.style.opacity = "0"
      setTimeout(() => this.element.remove(), 500)
    }, 3000)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}

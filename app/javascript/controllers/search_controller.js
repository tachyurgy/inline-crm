import { Controller } from "@hotwired/stimulus"

// Submits a search form on input with debounce
export default class extends Controller {
  static targets = ["input"]

  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, 300)
  }
}

import { Controller } from "@hotwired/stimulus"

// Handles click-to-edit fields. Click displays an input, blur/enter saves via Turbo.
export default class extends Controller {
  static targets = ["display", "form"]

  edit() {
    this.displayTarget.classList.add("hidden")
    this.formTarget.classList.remove("hidden")
    const input = this.formTarget.querySelector("input, textarea, select")
    if (input) {
      input.focus()
      if (input.type !== "select-one") {
        input.select()
      }
    }
  }

  cancel() {
    this.formTarget.classList.add("hidden")
    this.displayTarget.classList.remove("hidden")
  }

  submit(event) {
    if (event.key === "Escape") {
      this.cancel()
      return
    }
    if (event.key === "Enter" && event.target.tagName !== "TEXTAREA") {
      event.preventDefault()
      event.target.closest("form").requestSubmit()
    }
  }

  success() {
    this.formTarget.classList.add("hidden")
    this.displayTarget.classList.remove("hidden")
  }
}

import { Controller } from "@hotwired/stimulus"

// Clears the note input after successful turbo stream submission
export default class extends Controller {
  static targets = ["input"]

  reset() {
    this.inputTarget.value = ""
  }
}

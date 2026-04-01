import { Controller } from "@hotwired/stimulus"

// Slide-over modal panel
export default class extends Controller {
  static targets = ["panel", "overlay"]

  open(event) {
    event.preventDefault()
    this.panelTarget.classList.remove("translate-x-full")
    this.overlayTarget.classList.remove("hidden")
    document.body.classList.add("overflow-hidden")

    // Load turbo frame if the link has a src
    const src = event.currentTarget.dataset.modalSrc
    if (src) {
      const frame = this.panelTarget.querySelector("turbo-frame")
      if (frame) frame.src = src
    }
  }

  close() {
    this.panelTarget.classList.add("translate-x-full")
    this.overlayTarget.classList.add("hidden")
    document.body.classList.remove("overflow-hidden")
  }

  // Close on successful form submission
  submitEnd(event) {
    if (event.detail.success) {
      this.close()
      // Reload the page to show new data
      Turbo.visit(window.location.href, { action: "replace" })
    }
  }
}

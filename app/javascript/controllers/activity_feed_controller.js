import { Controller } from "@hotwired/stimulus"

// Polls for new activity feed entries
export default class extends Controller {
  static values = { url: String, interval: { type: Number, default: 5000 } }

  connect() {
    this.poll()
  }

  disconnect() {
    clearTimeout(this.timeout)
  }

  poll() {
    this.timeout = setTimeout(() => {
      fetch(this.urlValue, {
        headers: { "Accept": "text/vnd.turbo-stream.html" }
      }).then(response => {
        if (response.ok) return response.text()
      }).then(html => {
        if (html) Turbo.renderStreamMessage(html)
      }).finally(() => {
        this.poll()
      })
    }, this.intervalValue)
  }
}

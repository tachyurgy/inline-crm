import { Controller } from "@hotwired/stimulus"

// Drag-and-drop pipeline board for deals
export default class extends Controller {
  static targets = ["card"]

  dragstart(event) {
    event.dataTransfer.setData("text/plain", event.target.dataset.dealId)
    event.dataTransfer.effectAllowed = "move"
    event.target.classList.add("opacity-50")
  }

  dragend(event) {
    event.target.classList.remove("opacity-50")
  }

  dragover(event) {
    event.preventDefault()
    event.dataTransfer.dropEffect = "move"
    event.currentTarget.classList.add("bg-blue-50")
  }

  dragleave(event) {
    event.currentTarget.classList.remove("bg-blue-50")
  }

  drop(event) {
    event.preventDefault()
    event.currentTarget.classList.remove("bg-blue-50")
    const dealId = event.dataTransfer.getData("text/plain")
    const newStage = event.currentTarget.dataset.stage

    const csrfToken = document.querySelector("meta[name='csrf-token']").content

    fetch(`/deals/${dealId}/move`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken,
        "Accept": "text/vnd.turbo-stream.html"
      },
      body: JSON.stringify({ deal: { stage: newStage } })
    }).then(response => response.text())
      .then(html => {
        Turbo.renderStreamMessage(html)
      })
  }
}

import { Controller } from "@hotwired/stimulus"

// Drag-and-drop pipeline board for deals -- supports cross-column moves and within-column reordering
export default class extends Controller {
  dragstart(event) {
    const card = event.target.closest("[data-deal-id]")
    if (!card) return
    event.dataTransfer.setData("text/plain", card.dataset.dealId)
    event.dataTransfer.effectAllowed = "move"
    card.classList.add("opacity-50")
    this.draggedCard = card
  }

  dragend(event) {
    const card = event.target.closest("[data-deal-id]")
    if (card) card.classList.remove("opacity-50")
    this.draggedCard = null
    // Remove all drop indicators
    this.element.querySelectorAll(".drop-indicator").forEach(el => el.remove())
    this.element.querySelectorAll(".bg-blue-50").forEach(el => el.classList.remove("bg-blue-50"))
  }

  dragover(event) {
    event.preventDefault()
    event.dataTransfer.dropEffect = "move"
    const column = event.currentTarget
    column.classList.add("bg-blue-50")

    // Show drop position indicator within the deals list
    const dealsList = column.querySelector("[id$='-deals']")
    if (!dealsList) return

    // Remove existing indicators
    this.element.querySelectorAll(".drop-indicator").forEach(el => el.remove())

    const cards = [...dealsList.querySelectorAll("[data-deal-id]")]
    const mouseY = event.clientY
    let insertBefore = null

    for (const card of cards) {
      const rect = card.getBoundingClientRect()
      if (mouseY < rect.top + rect.height / 2) {
        insertBefore = card
        break
      }
    }

    const indicator = document.createElement("div")
    indicator.className = "drop-indicator h-1 bg-blue-400 rounded-full mx-2 my-1"

    if (insertBefore) {
      dealsList.insertBefore(indicator, insertBefore)
    } else {
      dealsList.appendChild(indicator)
    }
  }

  dragleave(event) {
    // Only remove highlight when truly leaving the column (not entering a child)
    if (!event.currentTarget.contains(event.relatedTarget)) {
      event.currentTarget.classList.remove("bg-blue-50")
      event.currentTarget.querySelectorAll(".drop-indicator").forEach(el => el.remove())
    }
  }

  drop(event) {
    event.preventDefault()
    event.currentTarget.classList.remove("bg-blue-50")
    this.element.querySelectorAll(".drop-indicator").forEach(el => el.remove())

    const dealId = event.dataTransfer.getData("text/plain")
    const column = event.currentTarget
    const newStage = column.dataset.stage
    const dealsList = column.querySelector("[id$='-deals']")
    if (!dealsList) return

    // Figure out position based on where we dropped
    const cards = [...dealsList.querySelectorAll("[data-deal-id]")]
    const mouseY = event.clientY
    let position = 0

    for (let i = 0; i < cards.length; i++) {
      const rect = cards[i].getBoundingClientRect()
      if (mouseY > rect.top + rect.height / 2) {
        position = i + 1
      }
    }

    const csrfToken = document.querySelector("meta[name='csrf-token']").content

    fetch(`/deals/${dealId}/move`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken,
        "Accept": "text/vnd.turbo-stream.html"
      },
      body: JSON.stringify({ deal: { stage: newStage, position: position } })
    }).then(response => response.text())
      .then(html => {
        Turbo.renderStreamMessage(html)
      })
  }
}

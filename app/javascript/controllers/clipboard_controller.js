import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets = ["text", "icon"]

  copy(event) {
    this.iconTarget.classList.add("ri-check-line")
    this.iconTarget.classList.remove("ri-file-copy-line")

    navigator.clipboard.writeText(this.textTarget.value).catch((error) => {
      console.error('Error copying text:', error);
    });
  }
}

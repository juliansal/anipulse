import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['input', 'name']

  update() {
    if (this.inputTarget.files.length > 0) {
      this.nameTarget.textContent = this.inputTarget.files[0].name
    } else {
      this.nameTarget.textContent = 'No file chosen'
    }
  }
}

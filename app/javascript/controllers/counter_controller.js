import { Controller } from "@hotwired/stimulus"
import { CountUp } from 'countup.js';

// Connects to data-controller="counter"
export default class extends Controller {
  static targets = ["counter"]

  connect() {
    let countUp = new CountUp(this.counterTarget, parseInt(this.counterTarget.innerText), { enableScrollSpy: true, duration: 3 });
    if (!countUp.error) {
      countUp.start();
    } else {
      console.error(countUp.error);
    }
  }
}

// https://github.com/inorganik/countUp.js

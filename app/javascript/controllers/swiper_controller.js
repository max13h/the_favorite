import { Controller } from "@hotwired/stimulus"
import { register } from 'swiper/element/bundle';

// Connects to data-controller="swiper"
export default class extends Controller {

  connect() {
    register();
  }
}

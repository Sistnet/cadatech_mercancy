import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js"

export default class extends Controller {
  static values = {
    type: { type: String, default: "bar" },
    data: Object,
    options: { type: Object, default: {} }
  }

  connect() {
    const ctx = this.element.getContext("2d")
    const defaultOptions = {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: { display: this.typeValue !== "bar" && this.typeValue !== "line" }
      }
    }

    this.chart = new Chart(ctx, {
      type: this.typeValue,
      data: this.dataValue,
      options: { ...defaultOptions, ...this.optionsValue }
    })
  }

  disconnect() {
    if (this.chart) {
      this.chart.destroy()
      this.chart = null
    }
  }
}

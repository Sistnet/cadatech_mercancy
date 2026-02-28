import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "backdrop"]

  connect() {
    this.mediaQuery = window.matchMedia("(min-width: 1024px)")
    this.handleResize = this.handleResize.bind(this)
    this.mediaQuery.addEventListener("change", this.handleResize)
    this.syncState()
    this.render()
  }

  disconnect() {
    this.mediaQuery.removeEventListener("change", this.handleResize)
  }

  toggle() {
    this.open = !this.open
    if (this.mediaQuery.matches) {
      localStorage.setItem("sidebar", this.open ? "open" : "closed")
    }
    this.render()
  }

  close() {
    this.open = false
    this.render()
  }

  handleResize() {
    this.syncState()
    this.render()
  }

  syncState() {
    if (this.mediaQuery.matches) {
      this.open = localStorage.getItem("sidebar") !== "closed"
    } else {
      this.open = false
    }
  }

  render() {
    const sidebar = this.sidebarTarget
    const backdrop = this.backdropTarget
    const isDesktop = this.mediaQuery.matches

    if (isDesktop) {
      backdrop.classList.add("hidden")
      sidebar.classList.remove("-translate-x-full")

      if (this.open) {
        sidebar.classList.remove("w-16")
        sidebar.classList.add("w-64")
        document.documentElement.style.setProperty("--sidebar-width", "16rem")
      } else {
        sidebar.classList.remove("w-64")
        sidebar.classList.add("w-16")
        document.documentElement.style.setProperty("--sidebar-width", "4rem")
      }
    } else {
      sidebar.classList.remove("w-16")
      sidebar.classList.add("w-64")

      if (this.open) {
        sidebar.classList.remove("-translate-x-full")
        backdrop.classList.remove("hidden")
      } else {
        sidebar.classList.add("-translate-x-full")
        backdrop.classList.add("hidden")
      }
      document.documentElement.style.setProperty("--sidebar-width", "0px")
    }

    sidebar.querySelectorAll("[data-sidebar-label]").forEach((el) => {
      if (!isDesktop || this.open) {
        el.classList.remove("hidden")
      } else {
        el.classList.add("hidden")
      }
    })
  }
}

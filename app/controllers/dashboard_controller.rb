class DashboardController < ApplicationController
  def index
    @period = params[:period] || "today"
    @kpis = {
      orders: { value: 124, previous: 110 },
      revenue: { value: 8450.00, previous: 7820.00 },
      customers: { value: 38, previous: 33 },
      products: { value: 256, previous: 261 },
      ticket: { value: 68.15, previous: 66.20 }
    }
    @sales_chart = sales_chart_data
    @status_chart = status_chart_data
    @recent_orders = recent_orders_data
    @recent_activity = recent_activity_data
  end

  private

  def sales_chart_data
    labels = 7.times.map { |i| (6 - i).days.ago.strftime("%d/%m") }
    {
      labels: labels,
      datasets: [ {
        label: I18n.t("dashboard.charts.sales_label"),
        data: [ 1250, 980, 1540, 1320, 1680, 1450, 1230 ],
        borderColor: "rgb(37, 99, 235)",
        backgroundColor: "rgba(37, 99, 235, 0.1)",
        fill: true,
        tension: 0.3
      } ]
    }
  end

  def status_chart_data
    {
      labels: %w[confirmado pendente processando enviado entregue cancelado].map { |s| I18n.t("dashboard.statuses.#{s}") },
      datasets: [ {
        data: [ 35, 22, 18, 15, 28, 6 ],
        backgroundColor: [
          "rgb(34, 197, 94)",
          "rgb(234, 179, 8)",
          "rgb(59, 130, 246)",
          "rgb(168, 85, 247)",
          "rgb(16, 185, 129)",
          "rgb(239, 68, 68)"
        ]
      } ]
    }
  end

  def recent_orders_data
    [
      { id: 1052, customer: "Maria Silva", total: 245.90, status: "entregue", date: 1.hour.ago },
      { id: 1051, customer: "João Santos", total: 89.90, status: "enviado", date: 2.hours.ago },
      { id: 1050, customer: "Ana Oliveira", total: 432.00, status: "processando", date: 3.hours.ago },
      { id: 1049, customer: "Carlos Lima", total: 67.50, status: "pendente", date: 4.hours.ago },
      { id: 1048, customer: "Fernanda Costa", total: 198.00, status: "confirmado", date: 5.hours.ago },
      { id: 1047, customer: "Ricardo Souza", total: 312.40, status: "entregue", date: 6.hours.ago },
      { id: 1046, customer: "Patrícia Alves", total: 156.80, status: "cancelado", date: 7.hours.ago },
      { id: 1045, customer: "Bruno Ferreira", total: 89.90, status: "enviado", date: 8.hours.ago },
      { id: 1044, customer: "Juliana Ribeiro", total: 534.20, status: "entregue", date: 9.hours.ago },
      { id: 1043, customer: "Marcos Pereira", total: 78.00, status: "pendente", date: 10.hours.ago }
    ]
  end

  def recent_activity_data
    [
      { admin: "Admin", action: "fez login no sistema", time: 30.minutes.ago },
      { admin: "Admin", action: "alterou status do pedido #1052 para Entregue", time: 1.hour.ago },
      { admin: "Admin", action: "atualizou produto \"Camiseta Básica\"", time: 2.hours.ago },
      { admin: "Admin", action: "confirmou pedido #1050", time: 3.hours.ago },
      { admin: "Admin", action: "adicionou novo produto \"Tênis Runner\"", time: 4.hours.ago },
      { admin: "Admin", action: "cancelou pedido #1046", time: 7.hours.ago },
      { admin: "Admin", action: "atualizou estoque de 12 produtos", time: 8.hours.ago },
      { admin: "Admin", action: "fez login no sistema", time: 1.day.ago }
    ]
  end
end

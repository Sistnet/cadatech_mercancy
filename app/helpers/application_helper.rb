module ApplicationHelper
  PER_PAGE = 20

  def pagination_info(offset, limit, total)
    first = [ offset + 1, total ].min
    last = [ offset + limit, total ].min
    t("pagination.showing", first: first, last: last, total: total)
  end
end

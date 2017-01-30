json.total_pages @total_pages
json.(@paginate_params, :page, :per_page)

json.products @products
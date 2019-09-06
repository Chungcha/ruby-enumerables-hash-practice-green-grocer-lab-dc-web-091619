
def consolidate_cart(cart)
  final_hash={}
  cart.each do |food_items|
    item_name = food_items.keys[0]
    item_info = food_items.values[0]
    if final_hash.any?{|key,value|key==item_name}
      final_hash[item_name][:count] += 1
    else
      final_hash[item_name]=item_info
      item_info[:count] = 1
=begin
      final_hash[item_name]={
        price: food_items[:price],
        clearance: food_items[:clearance],
        count: 1
      }
=end
    end
  end
  final_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item = coupon[:item]
    if cart[item] && cart[item][:count]>=coupon[:num] && !cart["#{item} W/COUPON"]
      cart["#{item} W/COUPON"]= {
        price: coupon[:cost]/coupon[:num],
        clearance: cart[item][:clearance],
        count: coupon[:num]
      }
      cart[item][:count]-=coupon[:num]
    elsif cart[item] && cart[item][:count]>=coupon[:num] && cart["#{item} W/COUPON"]
      cart["#{item} W/COUPON"][:count] += coupon[:num]
      cart[item][:count]-= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.map do |key, values|
    if values[:clearance] == TRUE #not key[:clearance]??
      cart[key][:price]= (cart[key][:price]*0.80).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  total=0
  consolidate_cart(cart).map do |key,value|
    total+=value[:price]
  end
  total
  apply_coupons(cart, coupons).map do |key,value|
    total+=value[:price]
  end
  total
end

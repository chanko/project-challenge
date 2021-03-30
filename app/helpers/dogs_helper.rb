module DogsHelper
  def like_unlike_links(dog)
    return if dog.owner == current_user

    link_to('Like', like_dog_path(dog), method: :put) + '/' + 
    link_to('Unlike', unlike_dog_path(dog), method: :put)
  end
end

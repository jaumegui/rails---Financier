class MatchsController < ApplicationController
  def index
    @date = params[:date]
  end

  def new
    @date = params[:date]
    url = "http://www.allomatch.com/fr/match/listTv?team=Tapez%20une%20%C3%A9quipe%20ou%20un%20tournoi%20ici&channels=&match-search-from=#{@date.split('-')[2]}%2F#{@date.split('-')[1]}%2F#{@date.split('-')[0]}&match-search-to=#{@date.split('-')[2]}%2F#{@date.split('-')[1]}%2F#{@date.split('-')[0]}&sport_id=&important_dates=#{@date}"
    html_content = open(url).read
    doc = Nokogiri::HTML(html_content)

    game = []
    doc.xpath('//span[@class="summary"]').each do |element|
      game << element.text
    end

    hour = []
    doc.xpath('//div[@class="dtstart match-tv-time"]').each do |element|
      hour << element.text.strip
    end

    channel = []
    doc.xpath('//div[@class="list-match-channels"]').each do |element|
      channel << element.text.strip
    end
    channels = channel.map do |element|
      element.gsub(/(\n\s*)+/,',')
    end

    final = channels.map do |element|
      element.split(',')
    end

    if Day.exists?(name: params[:date])
      Day.find_by(name: params[:date]).destroy
      @day = Day.new(name: @date)
    end
    @day = Day.new(name: @date)
    @day.save

    for i in 0..game.size - 1 do
      @match = Match.new(name: game[i], hour: hour[i], channel: final[i].join(' / '), day_id: @day.id)
      @match.save
    end
    @day = Day.find_by(name: params[:date])
    redirect_to match_path(params[:date])
  end

  def show
    @date = params[:date]
    @day = Day.find_by(name: @date)
  end

  def delete
    @match = Match.find_by(id: params[:id])
    @day = Day.find_by(id: @match.day_id)
    @match.destroy
    redirect_to match_path(@day.name)
  end
end
	
@available_channels = ["TF1", "France 2", "France 3", "Canal +", "Canal + Sport", "Canal + Décalé", "beIN SPORTS 1", "beIN SPORTS 2", "BeIN SPORTS 3", "beIN SPORTS MAX 4", "beIN SPORTS MAX 5", "beIN SPORTS MAX 6", "beIN SPORTS MAX 7", "beIN SPORTS MAX 8", "beIN SPORTS MAX 9", "RMC Sport 1", "RMC Sport 2", "RMC Sport 3", "Eurosport", "Eurosport 2", "La Chaîne l'Equipe"]

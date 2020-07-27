class Gossip
  attr_accessor :author, :content

  def initialize(author, content)
    @author = author
    @content = content
  end

  def save
    CSV.open("./db/gossip.csv", "ab") do |csv|
      csv << [@author, @content]
    end
  end

  def self.all
    all_gossips = []
    CSV.read("./db/gossip.csv").each do |csv_line|
      all_gossips << Gossip.new(csv_line[0], csv_line[1])
    end
    return all_gossips
  end

  def self.id(id)
    all_gossips = Gossip.all
    return all_gossips[id.to_i - 1]
  end

  def self.update(id, author, content)
    #Récupérer le gossip à mettre à jour à l'aide de son ID
    selected_gossip = Gossip.id(id)
    #Récupérer la liste de tous les gossips
    all_gossips = Gossip.all
    #Initiation du tableau
    updated_gossips = []

    all_gossips.each do |gossip|
      if gossip.author == selected_gossip.author && gossip.content == selected_gossip.content
        #Si il s'agit du gossip ciblé, update
        updated_gossips << Gossip.new(author, content)
      else
        #Si le gossip actellement dans la boucle n'est pas celui concerné, on ne fait rien
        updated_gossips << gossip
      end
    end

    #Suppression du "fichier BDD"
    File.delete('./db/gossip.csv') if File.exists? './db/gossip.csv'

    #On reenregistre un nouveau fichier CSV avec les nouvelles valeurs
    updated_gossips.each do |gossip|
      gossip.save
    end
  end
end
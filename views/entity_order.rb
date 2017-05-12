require './views/base'

module Views
  class EntityOrder < Base
    needs :game
    needs entities: nil

    def content
      (entities || game.active_entities).each_with_index do |entity, index|
        s = {
          display: 'inline-block',
          margin: '0 5px 5px 0',
          padding_left: '5px',
        }

        s[:text_decoration] = 'underline' if game.acting.include? entity
        s[:border_left] = 'black solid thin' if index > 0

        div style: inline(s) do
          str = String.new entity.name
          str << " (#{entity.owner.name})" if !entity.is_a?(Player) && entity.owner
          text str
        end
      end

    end

  end
end

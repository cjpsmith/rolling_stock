require './views/base'
require './views/action'

module Views
  class IssueShares < Action
    needs :game
    needs :current_player

    def render_action
      widget EntityOrder, game: game, entities: game.corporations

      corporation = game.acting.first

      widget Corporations, game: game, corporations: [corporation]

      game_form do
        input type: 'hidden', name: data('corporation'), value: corporation.name
        input type: 'submit', style: inline(margin_left: '5px'), value: 'Issue a Share'
      end if game.can_act? current_player
    end
  end
end

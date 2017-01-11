require './views/base'

module Views
  class Game < Base
    needs :game
    needs :current_user

    def content
      @current_player = game.player_by_id current_user&.id
      game.new_game? ? render_new : render_game
    end

    def render_new
      div class: 'wrapper' do
        game.players.each do |player|
          div player.name
        end

        render_join_button if !game.players.include?(@current_player) && game.new_game?
        render_start_button if game.user == current_user
      end
    end

    def render_game
      flash_title if game.can_act? @current_player

      tier = game.ownership_tier

      div class: 'heading' do
        text "Round: #{game.round} Phase: #{game.phase} (#{game.phase_name})"
      end

      widget Log, game: game, current_player: @current_player
      widget LogChat, game: game, current_player: @current_player

      render_action_widget

      div(class: 'heading') { text 'Players' }

      div class: 'wrapper' do
        widget Players, players: game.players, tier: tier, current_player: @current_player
      end

      div(class: 'heading') { text 'Corporations' }

      div class: 'wrapper' do
        widget Corporations, corporations: game.corporations, tier: tier
      end

      widget ForeignInvestor, investor: game.foreign_investor, tier: tier

      widget Deck, {
        companies: game.companies,
        pending_companies: game.pending_companies,
        company_deck: game.company_deck,
        tier: tier,
      }

      widget SharePrices, share_prices: game.share_prices
    end

    def render_join_button
      form action: app.path(game, 'join'), method: 'post' do
        rawtext app.csrf_tag
        input type: 'submit', value: 'Join As Player'
      end
    end

    def render_start_button
      form action: app.path(game, 'start'), method: 'post' do
        rawtext app.csrf_tag
        input type: 'submit', value: 'Start Game'
      end
    end

    def render_action_widget
      case game.phase
      when 1
        render_action IssueShares
      when 2
        render_action FormCorporations
      when 3
        render_action AuctionCompanies
      when 6
        render_action BuyCompanies
      when 7
        render_action CloseCompanies
      when 9
        render_action PayDividends
      end
    end

    def render_action klass
      widget klass, game: game, current_player: @current_player
    end

    def flash_title
      script <<~JS
        var Game = {
          flash: function() {
            var self = this;

            setTimeout(function(){
              document.title = "Your Turn - #{game.phase_name}";

              setTimeout(function(){
                document.title = self.title;
                self.flash();
              }, 2000);
            }, 2000);
          }
        }

        Game.title = document.title;
        Game.flash();
      JS
    end
  end
end

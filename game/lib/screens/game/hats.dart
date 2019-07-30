import 'dart:ui';

import 'spritesheet.dart';
import 'player.dart';
import '../../main.dart';

import 'package:flame/sprite.dart';

enum Hat {
  RIDER,
  WIZARD,
  GENTLEMAN,
  COP,
  KING,
  COWBOY,
  BASEBALL_CAP,
  SOMBRERO,
  ASTRONAUT,
  KNIGHT,
  SPARTAN,
  SANTA,
  JESTER,
  WANDERER,
  COMPOSER,
  DIVER,
  OLD_DIVER,
  CONSTRUCTION_WORKER,
  GRADUATE,
  CHEF,
  PIRATE_CAPTAIN,
  ASSASSIN,
  LEPRECHAUN,
  FRANK,
  PHARAOH,
  VIKING,
  DRINKING_HAT,
  ARCHER,
}

class HatSprite {
  SpriteSheet _spriteSheet;

  Hat _hat;

  HatSprite(this._hat, { Image image }) {
    _spriteSheet = SpriteSheet(
        image: image,
        textureWidth: 48,
        textureHeight: 32,
        rows: 7,
        columns: 4
    );
  }

  void render(Canvas canvas, double x, double y, bool isGrowed, bool isShrunk) {

    final delta = (isGrowed ? Player.GROW_RATE : isShrunk ? Player.SHRUNK_RATE : 1.0);

    hatSprite.renderRect(
        canvas,
        Rect.fromLTWH(
            x - 50 * delta,
            y - 50 * delta,
            150 * delta,
            100 * delta
            )
        );
  }

  Sprite get rider => _spriteSheet.getSprite(0, 0);
  Sprite get wizard => _spriteSheet.getSprite(1, 0);
  Sprite get gentleman => _spriteSheet.getSprite(2, 0);
  Sprite get cop => _spriteSheet.getSprite(3, 0);
  Sprite get king => _spriteSheet.getSprite(4, 0);
  Sprite get cowboy => _spriteSheet.getSprite(5, 0);
  Sprite get baseballCap => _spriteSheet.getSprite(6, 0);

  Sprite get sombrero => _spriteSheet.getSprite(0, 1);
  Sprite get astronaut => _spriteSheet.getSprite(1, 1);
  Sprite get knight => _spriteSheet.getSprite(2, 1);
  Sprite get spartan => _spriteSheet.getSprite(3, 1);
  Sprite get santa => _spriteSheet.getSprite(4, 1);
  Sprite get jester => _spriteSheet.getSprite(5, 1);
  Sprite get wanderer => _spriteSheet.getSprite(6, 1);

  Sprite get composer => _spriteSheet.getSprite(0, 2);
  Sprite get diver => _spriteSheet.getSprite(1, 2);
  Sprite get oldDiver => _spriteSheet.getSprite(2, 2);
  Sprite get constructionWorker => _spriteSheet.getSprite(3, 2);
  Sprite get graduate => _spriteSheet.getSprite(4, 2);
  Sprite get chef => _spriteSheet.getSprite(5, 2);
  Sprite get pirateCaptain => _spriteSheet.getSprite(6, 2);

  Sprite get assassin => _spriteSheet.getSprite(0, 3);
  Sprite get leprechaun => _spriteSheet.getSprite(1, 3);
  Sprite get frank => _spriteSheet.getSprite(2, 3);
  Sprite get pharaoh => _spriteSheet.getSprite(3, 3);
  Sprite get viking => _spriteSheet.getSprite(4, 3);
  Sprite get drinkingHat => _spriteSheet.getSprite(5, 3);
  Sprite get archer => _spriteSheet.getSprite(6, 3);

  String get label {
    switch(_hat) {
      case Hat.RIDER: {
        return "Rider";
      }
      case Hat.WIZARD: {
        return "Wizard";
      }
      case Hat.GENTLEMAN: {
        return "Gentleman";
      }
      case Hat.COP: {
        return "Cop";
      }
      case Hat.KING: {
        return "King";
      }
      case Hat.COWBOY: {
        return "Cowboy";
      }
      case Hat.BASEBALL_CAP: {
        return "Baseball Cap";
      }
      case Hat.SOMBRERO: {
        return "Sombrero";
      }
      case Hat.ASTRONAUT: {
        return "Astronaut";
      }
      case Hat.KNIGHT: {
        return "Knight";
      }
      case Hat.SPARTAN: {
        return "Spartan";
      }
      case Hat.SANTA: {
        return "Santa";
      }
      case Hat.JESTER: {
        return "Jester";
      }
      case Hat.WANDERER: {
        return "Wanderer";
      }
      case Hat.COMPOSER: {
        return "Composer";
      }
      case Hat.DIVER: {
        return "Diver";
      }
      case Hat.OLD_DIVER: {
        return "Old Diver";
      }
      case Hat.CONSTRUCTION_WORKER: {
        return "Worker";
      }
      case Hat.GRADUATE: {
        return "Graduate";
      }
      case Hat.CHEF: {
        return "Chef";
      }
      case Hat.PIRATE_CAPTAIN: {
        return "Pirate Captain";
      }
      case Hat.ASSASSIN: {
        return "Assassin";
      }
      case Hat.LEPRECHAUN: {
        return "Leprechaun";
      }
      case Hat.FRANK: {
        return "Frank";
      }
      case Hat.PHARAOH: {
        return "Pharaoh";
      }
      case Hat.VIKING: {
        return "Viking";
      }
      case Hat.DRINKING_HAT: {
        return "Drinking Hat";
      }
      case Hat.ARCHER: {
        return "Archer";
      }
    }
  }

  Sprite get hatSprite {
    switch(_hat) {
      case Hat.RIDER: {
        return rider;
      }
      case Hat.WIZARD: {
        return wizard;
      }
      case Hat.GENTLEMAN: {
        return gentleman;
      }
      case Hat.COP: {
        return cop;
      }
      case Hat.KING: {
        return king;
      }
      case Hat.COWBOY: {
        return cowboy;
      }
      case Hat.BASEBALL_CAP: {
        return baseballCap;
      }
      case Hat.SOMBRERO: {
        return sombrero;
      }
      case Hat.ASTRONAUT: {
        return astronaut;
      }
      case Hat.KNIGHT: {
        return knight;
      }
      case Hat.SPARTAN: {
        return spartan;
      }
      case Hat.SANTA: {
        return santa;
      }
      case Hat.JESTER: {
        return jester;
      }
      case Hat.WANDERER: {
        return wanderer;
      }
      case Hat.COMPOSER: {
        return composer;
      }
      case Hat.DIVER: {
        return diver;
      }
      case Hat.OLD_DIVER: {
        return oldDiver;
      }
      case Hat.CONSTRUCTION_WORKER: {
        return constructionWorker;
      }
      case Hat.GRADUATE: {
        return graduate;
      }
      case Hat.CHEF: {
        return chef;
      }
      case Hat.PIRATE_CAPTAIN: {
        return pirateCaptain;
      }
      case Hat.ASSASSIN: {
        return assassin;
      }
      case Hat.LEPRECHAUN: {
        return leprechaun;
      }
      case Hat.FRANK: {
        return frank;
      }
      case Hat.PHARAOH: {
        return pharaoh;
      }
      case Hat.VIKING: {
        return viking;
      }
      case Hat.DRINKING_HAT: {
        return drinkingHat;
      }
      case Hat.ARCHER: {
        return archer;
      }
    }
  }
}

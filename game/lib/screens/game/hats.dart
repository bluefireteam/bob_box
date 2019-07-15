import 'dart:ui';

import 'spritesheet.dart';
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
}

class HatSprite {
  SpriteSheet _spriteSheet;

  Hat _hat;

  HatSprite(this._hat) {
    _spriteSheet = SpriteSheet(
        imageName: 'hats.png',
        textureWidth: 48,
        textureHeight: 32,
        rows: 7,
        columns: 3
    );
  }

  void render(Canvas canvas, double x, double y) {
    hatSprite.renderRect(canvas, Rect.fromLTWH(x - 50, y - 50, 150, 100));
  }

  Future<void> load() async {
    return await _spriteSheet.load();
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
    }
  }
}

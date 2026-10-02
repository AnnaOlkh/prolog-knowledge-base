:- encoding(utf8).

/*
    Лабораторна робота 1
    Предметна область:
    "Астрономічні об'єкти"
*/

% КЛАСИ

class(astronomical_object).
class(star).
class(planet).
class(terrestrial_planet).
class(gas_giant).
class(ice_giant).
class(dwarf_planet).
class(natural_satellite).
class(small_solar_system_body).
class(asteroid).
class(comet).
class(black_hole).

class(astronomical_system).
class(planetary_system).
class(galaxy).

% ІЄРАРХІЯ КЛАСІВ

subclass(star, astronomical_object).

subclass(planet, astronomical_object).
subclass(terrestrial_planet, planet).
subclass(gas_giant, planet).
subclass(ice_giant, planet).

subclass(dwarf_planet, astronomical_object).
subclass(natural_satellite, astronomical_object).

subclass(small_solar_system_body, astronomical_object).
subclass(asteroid, small_solar_system_body).
subclass(comet, small_solar_system_body).

subclass(black_hole, astronomical_object).

subclass(planetary_system, astronomical_system).
subclass(galaxy, astronomical_system).


% ЕКЗЕМПЛЯРИ КЛАСІВ

instance_of(sun, star).

instance_of(mercury, terrestrial_planet).
instance_of(venus, terrestrial_planet).
instance_of(earth, terrestrial_planet).
instance_of(mars, terrestrial_planet).

instance_of(jupiter, gas_giant).
instance_of(saturn, gas_giant).

instance_of(uranus, ice_giant).
instance_of(neptune, ice_giant).

instance_of(pluto, dwarf_planet).

instance_of(moon, natural_satellite).
instance_of(europa, natural_satellite).
instance_of(titan, natural_satellite).
instance_of(ganymede, natural_satellite).

instance_of(vesta, asteroid).
instance_of(halley_comet, comet).

instance_of(sagittarius_a_star, black_hole).

instance_of(solar_system, planetary_system).
instance_of(milky_way, galaxy).

% АТРИБУТИ

has_attribute(sun, spectral_class, g2v).

has_attribute(earth, composition, rocky).
has_attribute(earth, radius_km, 6371).

has_attribute(mars, composition, rocky).

has_attribute(jupiter, composition, gaseous).
has_attribute(saturn, composition, gaseous).

has_attribute(uranus, composition, ice_rich).
has_attribute(neptune, composition, ice_rich).

has_attribute(halley_comet, composition, ice_and_dust).
has_attribute(halley_comet, orbital_period_years, 75.3).

has_attribute(
    sagittarius_a_star,
    black_hole_type,
    supermassive
).


% АСОЦІАТИВНІ ЗВ'ЯЗКИ

orbits(mercury, sun).
orbits(venus, sun).
orbits(earth, sun).
orbits(mars, sun).
orbits(jupiter, sun).
orbits(saturn, sun).
orbits(uranus, sun).
orbits(neptune, sun).

orbits(pluto, sun).
orbits(vesta, sun).
orbits(halley_comet, sun).

orbits(moon, earth).
orbits(europa, jupiter).
orbits(ganymede, jupiter).
orbits(titan, saturn).

central_star_of(sun, solar_system).

part_of(solar_system, milky_way).

located_in(sagittarius_a_star, milky_way).


% НЕСУМІСНІ КЛАСИ

disjoint(star, planet).
disjoint(star, dwarf_planet).
disjoint(star, natural_satellite).
disjoint(star, black_hole).

disjoint(planet, dwarf_planet).
disjoint(planet, natural_satellite).

disjoint(dwarf_planet, natural_satellite).


% ПРАВИЛА

subclass_of(Subclass, Superclass) :-
    subclass(Subclass, Superclass).

subclass_of(Subclass, Superclass) :-
    subclass(Subclass, Intermediate),
    subclass_of(Intermediate, Superclass).



is_a(Object, Class) :-
    instance_of(Object, Class).

is_a(Object, Superclass) :-
    instance_of(Object, Class),
    subclass_of(Class, Superclass).


planet_of_star(Planet, Star) :-
    orbits(Planet, Star),
    is_a(Planet, planet),
    is_a(Star, star).


has_satellite(Planet, Satellite) :-
    orbits(Satellite, Planet),
    is_a(Satellite, natural_satellite),
    is_a(Planet, planet).


central_star(Object, Star) :-
    orbits(Object, Star),
    is_a(Star, star).

central_star(Object, Star) :-
    orbits(Object, Parent),
    central_star(Parent, Star).


belongs_to_system(Star, System) :-
    central_star_of(Star, System).

belongs_to_system(Object, System) :-
    central_star(Object, Star),
    central_star_of(Star, System).


same_planetary_system(Object1, Object2, System) :-
    belongs_to_system(Object1, System),
    belongs_to_system(Object2, System),
    Object1 \= Object2.


satellite_of_gas_giant(Satellite, Planet) :-
    has_satellite(Planet, Satellite),
    is_a(Planet, gas_giant).

located_in_galaxy(Object, Galaxy) :-
    located_in(Object, Galaxy),
    is_a(Galaxy, galaxy).

located_in_galaxy(Object, Galaxy) :-
    belongs_to_system(Object, System),
    part_of(System, Galaxy),
    is_a(Galaxy, galaxy).

% ПЕРЕВІРКА УЗГОДЖЕНОСТІ

disjoint_classes(Class1, Class2) :-
    disjoint(Class1, Class2).

disjoint_classes(Class1, Class2) :-
    disjoint(Class2, Class1).

conflicting_types(Object, Class1, Class2) :-
    is_a(Object, Class1),
    is_a(Object, Class2),
    Class1 @< Class2,
    disjoint_classes(Class1, Class2).

self_orbit(Object) :-
    orbits(Object, Object).

unknown_instance_of_class(Object, Class) :-
    instance_of(Object, Class),
    \+ class(Class).


unknown_subclass(Subclass, Superclass) :-
    subclass(Subclass, Superclass),
    (
        \+ class(Subclass)
    ;
        \+ class(Superclass)
    ).

invalid_orbit_type(Object, Center) :-
    orbits(Object, Center),
    (
        \+ is_a(Object, astronomical_object)
    ;
        \+ is_a(Center, astronomical_object)
    ).


invalid_central_star_relation(Star, System) :-
    central_star_of(Star, System),
    (
        \+ is_a(Star, star)
    ;
        \+ is_a(System, planetary_system)
    ).


model_issue(conflicting_types(Object, Class1, Class2)) :-
    conflicting_types(Object, Class1, Class2).

model_issue(self_orbit(Object)) :-
    self_orbit(Object).

model_issue(unknown_instance_of_class(Object, Class)) :-
    unknown_instance_of_class(Object, Class).

model_issue(unknown_subclass(Subclass, Superclass)) :-
    unknown_subclass(Subclass, Superclass).

model_issue(invalid_orbit_type(Object, Center)) :-
    invalid_orbit_type(Object, Center).

model_issue(invalid_central_star_relation(Star, System)) :-
    invalid_central_star_relation(Star, System).


% ============================================================
% 9. ПРИКЛАДИ ПОМИЛКОВИХ ФАКТІВ
%
% Вони ЗАКОМЕНТОВАНІ.
% Можна тимчасово розкоментувати під час демонстрації
% перевірки узгодженості.
% ============================================================

% instance_of(earth, star).
%
% Після цього:
% ?- model_issue(Issue).
%
% буде знайдено конфлікт між star і planet.


% orbits(moon, moon).
%
% Після цього model_issue/1 виявить self_orbit(moon).


% instance_of(test_object, unknown_class).
%
% Після цього буде виявлено:
% unknown_instance_of_class(test_object, unknown_class).


% ============================================================
% 10. ПРИКЛАДИ ЗАПИТІВ
%
% Це коментарі, а не частина програми.
% Запити треба вводити у SWI-Prolog REPL.
% ============================================================

% ?- is_a(jupiter, planet).
% ?- is_a(jupiter, astronomical_object).
% ?- planet_of_star(Planet, sun).
% ?- has_satellite(jupiter, Satellite).
% ?- satellite_of_gas_giant(Satellite, Planet).
% ?- central_star(moon, Star).
% ?- belongs_to_system(moon, solar_system).
% ?- same_planetary_system(earth, europa, solar_system).
% ?- located_in_galaxy(earth, Galaxy).
% ?- model_issue(Issue).
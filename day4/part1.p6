use v6;
# use Grammar::Tracer;

grammar Schedule {
  token TOP { <line>+ }
  rule line { '[' <date> <time> ']' [ <shift> | <sleep> | <wake> ] }
  token date { <year=num> '-' <month=num> '-' <day=num> }
  token time { <hour=num> ':' <minute=num> }
  rule shift { 'Guard' '#' <id=num> 'begins shift' }
  rule sleep { 'falls asleep' }
  rule wake { 'wakes up' }
  token num { \d+ }
}

class Event {
  has Int $.time;
  has Str $.evt;
  has Int $.id;
}

class ScheduleAction {
  method TOP($/) {
    make $<line>».made;
  }
  method line($/) {
    my $evt;
    my Int $id;
    if $<shift> {
      $evt = 'shift';
      $id = $<shift><id>.made;
    }
    if $<sleep> {
      $evt = 'sleep';
    }
    if $<wake> {
      $evt = 'wake';
    }
    make Event.new(
      time => $<date>.made × (60 × 24) + $<time>.made,
      :$evt,
      :$id,
    )
  }
  method num($/) {
    make $/.Int;
  }
  method time($/) {
    make $<hour>.made × 60 + $<minute>.made;
  }
  method date($/) {
    make $<year>.made × 366 + $<month>.made × 31 + $<day>.made;
  }
}

my @ev = Schedule.parse('input'.IO.slurp, actions => ScheduleAction).made.sort({ $^a.time cmp $^b.time } );

class Guard {
  has Int @.sleep is default(0) is rw;
  has Int $.total is rw = 0;
  has Int $.id;
}

my Guard %guards;
my $current;
my $st;

for @ev -> $ev {
  given $ev.evt {
    when "shift" {
      $current = $ev.id;
      if not %guards{$current}:exists {
        %guards{$current} = Guard.new(id => $current);
      }
    }
    when "sleep" {
      $st = $ev.time;
    }
    when "wake" {
      say "Sleep: $current from $($st % 60) to $($ev.time % 60) - $($ev.time - $st)";
      %guards{$current}.total += $ev.time - $st;
      %guards{$current}.sleep[($st % 60) .. $($ev.time % 60) - 1] »+=» 1;
    }
  }
}

say %guards;
my $sleepy = %guards.List».value.sort({ $^b.total cmp $^a.total }).first;
say $sleepy;
say $sleepy.sleep.maxpairs;

say "Part 1: $($sleepy.id × $sleepy.sleep.maxpairs.first.key)";

my $fm = %guards.max({ .value.sleep.max }).value;

say "Part 2: $($fm.id × $fm.sleep.maxpairs.first.key)";

use std::time::Duration;

use caca::{self, AnsiColor};

use board::Board;
use point::Point;

make_global!(DISPLAY, caca::Display, make_display(100, 40));

pub fn set_size(w: i32, h: i32) {
    instance::with_mut(|d| d.canvas().set_size(w, h));
}

pub fn get_event() -> Option<caca::Event> {
    instance::with(|d| d.poll_event(caca::EVENT_ANY.bits()))
}

pub fn print(board: &Board) {
    instance::with_mut(|d| {
        {
            let mut canvas = d.canvas();
            canvas.clear();
            canvas.set_color_ansi(&AnsiColor::LightGray, &AnsiColor::Black);
            for i in 0..board.width() {
                for j in 0..board.height() {
                    let pos = Point::new(i, j);
                    let ch = board.get(&pos).to_char();
                    canvas.put_char(i, j, ch);
                }
            }
        }
        d.set_display_time(Duration::new(30, 10000));
        d.refresh();
    });
}

fn make_display(w: i32, h: i32) -> caca::Display {
    let canvas = caca::Canvas::new(w, h).unwrap();
    caca::Display::new(caca::InitOptions{ canvas: Some(&canvas), .. caca::InitOptions::default()}).unwrap()
}

pub fn clear() {
    instance::with_mut(|d| d.canvas().clear());
}

pub fn put(x: i32, y: i32, ch: char) {
    instance::with_mut(|d| {
        let mut canvas = d.canvas();
        canvas.set_color_ansi(&AnsiColor::White, &AnsiColor::Black);
        canvas.put_char(x, y, ch);
    })
}

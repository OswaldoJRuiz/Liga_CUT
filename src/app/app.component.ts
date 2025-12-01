import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';   // <--- Importa esto

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet],  // <--- Agrega RouterOutlet aquí
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'frontend-liga';
}

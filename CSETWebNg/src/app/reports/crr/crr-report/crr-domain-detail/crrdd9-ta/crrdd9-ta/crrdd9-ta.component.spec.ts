import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Crrdd9TaComponent } from './crrdd9-ta.component';

describe('Crrdd9TaComponent', () => {
  let component: Crrdd9TaComponent;
  let fixture: ComponentFixture<Crrdd9TaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ Crrdd9TaComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(Crrdd9TaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

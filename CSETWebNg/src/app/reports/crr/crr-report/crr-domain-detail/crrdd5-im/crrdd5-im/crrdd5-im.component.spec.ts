import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Crrdd5ImComponent } from './crrdd5-im.component';

describe('Crrdd5ImComponent', () => {
  let component: Crrdd5ImComponent;
  let fixture: ComponentFixture<Crrdd5ImComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ Crrdd5ImComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(Crrdd5ImComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

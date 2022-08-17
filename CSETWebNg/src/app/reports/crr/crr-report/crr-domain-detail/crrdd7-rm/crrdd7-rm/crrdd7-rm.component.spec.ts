import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Crrdd7RmComponent } from './crrdd7-rm.component';

describe('Crrdd7RmComponent', () => {
  let component: Crrdd7RmComponent;
  let fixture: ComponentFixture<Crrdd7RmComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ Crrdd7RmComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(Crrdd7RmComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

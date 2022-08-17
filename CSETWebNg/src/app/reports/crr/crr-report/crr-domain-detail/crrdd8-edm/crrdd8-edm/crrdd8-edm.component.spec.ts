import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Crrdd8EdmComponent } from './crrdd8-edm.component';

describe('Crrdd8EdmComponent', () => {
  let component: Crrdd8EdmComponent;
  let fixture: ComponentFixture<Crrdd8EdmComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ Crrdd8EdmComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(Crrdd8EdmComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

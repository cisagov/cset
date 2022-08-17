import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Crrdd4VmComponent } from './crrdd4-vm.component';

describe('Crrdd4VmComponent', () => {
  let component: Crrdd4VmComponent;
  let fixture: ComponentFixture<Crrdd4VmComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ Crrdd4VmComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(Crrdd4VmComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

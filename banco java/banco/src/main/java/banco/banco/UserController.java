package banco.banco;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/users")
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class UserController {
    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody User user) {
        return userService.register(user); // Ahora permite cualquier tipo de respuesta
    }



    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {
        return userService.login(request); // Ahora pasamos LoginRequest completo
    }



    @GetMapping("/me")
    public ResponseEntity<?> getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated() || authentication.getPrincipal().equals("anonymousUser")) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Usuario no autenticado");
        }

        String email = authentication.getName(); // Obtiene el email del usuario autenticado
        Optional<User> user = userService.findByEmail(email); // Busca el usuario en la BD

        if (user.isPresent()) {
            return ResponseEntity.ok(user.get()); // Asegura que ambos retornos sean ResponseEntity<User>
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Usuario no encontrado");
        }
    }

    @GetMapping("/balance")
    public ResponseEntity<?> getBalance(@RequestParam String email) {
        Optional<User> userOpt = userService.findByEmail(email);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            return ResponseEntity.ok(Map.of("balance", user.getBalance()));
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("msg", "Usuario no encontrado"));
    }



    @PostMapping("/update-balance")
    public ResponseEntity<?> updateBalance(@RequestBody Map<String, Object> payload) {
        String email = (String) payload.get("email");
        Double amount = ((Number) payload.get("newBalance")).doubleValue();

        Optional<User> userOpt = userService.findByEmail(email);
        if (userOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Usuario no encontrado");
        }

        User user = userOpt.get();
        user.setBalance(user.getBalance() + amount); // Actualizar balance
        userService.save(user);

        return ResponseEntity.ok("Balance actualizado correctamente");
    }




}


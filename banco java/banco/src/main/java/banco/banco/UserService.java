package banco.banco;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private PasswordEncoder passwordEncoder; // 🔥 Inyectar encriptador de contraseñas


    public ResponseEntity<?> login(LoginRequest loginRequest) {
        Optional<User> user = userRepository.findByEmail(loginRequest.getEmail());
        if (user.isPresent() && passwordEncoder.matches(loginRequest.getPassword(), user.get().getPassword())) {
            String token = jwtUtil.generateToken(user.get().getEmail());
            Map<String, Object> response = new HashMap<>();
            response.put("token", token);
            response.put("userId", user.get().getId());
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Credenciales incorrectas");
    }

    public void save(User user) {
        userRepository.save(user);
    }



    public ResponseEntity<?> register(User user) {
        if (userRepository.existsByEmail(user.getEmail())) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Collections.singletonMap("error", "El usuario ya existe"));
        }

        user.setPassword(passwordEncoder.encode(user.getPassword())); // 🔐 Encriptar contraseña
        userRepository.save(user);
        return ResponseEntity.ok(Collections.singletonMap("message", "Usuario registrado exitosamente"));
    }



    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }


}




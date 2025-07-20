<script lang="ts">
  import { Github, Instagram } from "@lucide/svelte";
  import "../app.css";

  let { children } = $props();
</script>

<div class="min-h-screen bg-black text-white">
  <div class="container mx-auto px-4 py-8">
    <div class="text-center mb-12">
      <h1 class="text-4xl md:text-6xl thai-text-gradient font-bold mb-4">
        Muay Thai
      </h1>
    </div>

    {@render children()}

    <div class="text-center mt-12 text-gray-500 text-sm">
      <p>Desenvolvido para treinos de Muay Thai</p>
      <div class="flex flex-column gap-2 justify-center mt-4">
        <ul>
          <a href="https://instagram.com/hicaro.danrlley" target="_blank">
            <Instagram />
          </a>
        </ul>
        <ul>
          <a href="https://github.com/HicaroD" target="_blank">
            <Github />
          </a>
        </ul>
      </div>
    </div>
  </div>
</div>
